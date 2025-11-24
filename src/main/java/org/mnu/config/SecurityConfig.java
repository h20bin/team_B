package org.mnu.config;

import javax.sql.DataSource;

import org.mnu.security.CustomUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
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
public class SecurityConfig extends WebSecurityConfigurerAdapter {

	@Setter(onMethod_ = { @Autowired })
	private PasswordEncoder passwordEncoder;
	
	@Setter(onMethod_ = { @Autowired })
	private DataSource dataSource;

	@Override
	protected void configure(HttpSecurity http) throws Exception {

		http.authorizeRequests()
			.antMatchers("/board/list").permitAll()
			.antMatchers("/board/register").hasRole("ADMIN")
			.antMatchers("/admin/**").hasRole("ADMIN")
			.antMatchers("/member/**").permitAll();

		http.formLogin()
			.loginPage("/member/login")
			.loginProcessingUrl("/login")
			.usernameParameter("userid");
		
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
