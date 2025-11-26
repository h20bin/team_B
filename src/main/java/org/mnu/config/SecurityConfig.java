package org.mnu.config;

import javax.sql.DataSource;

import org.mnu.security.CustomUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity; // 추가됨
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Configuration
@EnableWebSecurity
@Log4j2
@EnableGlobalMethodSecurity(prePostEnabled = true, securedEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Setter(onMethod_ = { @Autowired })
    private PasswordEncoder passwordEncoder;
    
    @Setter(onMethod_ = { @Autowired })
    private DataSource dataSource;

    // [중요] 정적 리소스(css, js, images, upload 등)는 보안 필터 자체를 거치지 않게 설정
    // 이렇게 하면 resources 폴더 내의 파일 접근 시 403이 절대 뜨지 않습니다.
    @Override
    public void configure(WebSecurity web) throws Exception {
        web.ignoring().antMatchers("/resources/**", "/css/**", "/js/**", "/img/**", "/upload/**");
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {

        // [중요] CSRF 비활성화 (파일 업로드 시 403의 주범)
        // 개발 단계에서는 비활성화 해두는 것이 정신 건강에 좋습니다.
        http.csrf().disable();

        http.authorizeRequests()
            // 이미지 출력(/board/display), 목록(/board/list), 첫 페이지(/) 등은 로그인 없이 허용
            .antMatchers("/", "/board/list", "/board/display", "/board/getAttachList", "/board/get").permitAll()
            // 그 외 페이지 권한 설정
            .antMatchers("/board/register", "/board/modify", "/board/remove").authenticated() // 로그인 필요
            .antMatchers("/admin/**").hasAuthority("ROLE_ADMIN") // 관리자만
            .antMatchers("/member/**").permitAll()
            .antMatchers("/upload/**").permitAll()
            .anyRequest().authenticated(); // 나머지 모든 요청은 로그인 해야 함

        http.formLogin()
            .loginPage("/member/login")
            .loginProcessingUrl("/login")
            .usernameParameter("userid")
            .defaultSuccessUrl("/board/list", true); // 로그인 성공 시 이동할 곳 명시
        
        http.logout()
            .logoutUrl("/member/logout")
            .invalidateHttpSession(true)
            .deleteCookies("remember-me", "JSESSION_ID");

        http.rememberMe()
            .key("mnu")
            .tokenRepository(persistentTokenRepository())
            .tokenValiditySeconds(604800);
    }

    @Bean
    public UserDetailsService customUserService() {
        return new CustomUserDetailsService();
    }
    
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(customUserService()).passwordEncoder(passwordEncoder);
    }
    
    @Bean
    public PersistentTokenRepository persistentTokenRepository() {
        JdbcTokenRepositoryImpl repo = new JdbcTokenRepositoryImpl();
        repo.setDataSource(dataSource);
        return repo;
    }
}