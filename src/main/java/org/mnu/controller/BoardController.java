package org.mnu.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.mnu.domain.AttachVO;
import org.mnu.domain.BoardVO;
import org.mnu.domain.Criteria;
import org.mnu.domain.MemberVO;
import org.mnu.domain.PageDTO;
import org.mnu.security.domain.CustomUser;
import org.mnu.service.BoardService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j2
@RequestMapping("/board")
@AllArgsConstructor
public class BoardController {

    private final BoardService service;

    private MemberVO getLoginUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof CustomUser) {
            return ((CustomUser) authentication.getPrincipal()).getMember();
        }
        return null;
    }

    private boolean isLoginUserAdmin() {
        MemberVO loginUser = getLoginUser();
        return loginUser != null && "ROLE_ADMIN".equals(loginUser.getAuth());
    }

    // 목록
    @GetMapping("/list")
    public void list(Criteria cri, Model model) {
        log.info("list: " + cri);
        model.addAttribute("list", service.getList(cri));
        model.addAttribute("pageMaker", new PageDTO(cri, service.getTotal(cri)));
        model.addAttribute("loginUser", getLoginUser());
        model.addAttribute("locations", service.getLocations());
    }

    // 등록 폼
    @GetMapping("/register")
    public void register() {}

    // 등록 처리
    @PostMapping("/register")
    public String register(BoardVO board,
                           MultipartFile[] uploadFile,
                           RedirectAttributes rttr) {

        log.info("register: " + board);

        String uploadFolder = "C:\\upload";
        List<AttachVO> attachList = new ArrayList<>();

        String uploadFolderPath = getFolder();
        File uploadPath = new File(uploadFolder, uploadFolderPath);
        if (!uploadPath.exists()) uploadPath.mkdirs();

        for (MultipartFile multipartFile : uploadFile) {
            if (multipartFile.isEmpty()) continue;

            String originalFileName = multipartFile.getOriginalFilename();
            if (originalFileName == null || originalFileName.trim().isEmpty()) continue;

            AttachVO attachVO = new AttachVO();
            try {
                UUID uuid = UUID.randomUUID();
                String storedFileName = uuid.toString() + "_" + originalFileName;

                File saveFile = new File(uploadPath, storedFileName);
                multipartFile.transferTo(saveFile);

                attachVO.setUuid(uuid.toString());
                attachVO.setFileName(originalFileName);
                attachVO.setUploadPath(uploadFolderPath);

                if (isImage(saveFile)) {
                    attachVO.setFileType(true);
                    FileOutputStream thumbnail =
                            new FileOutputStream(new File(uploadPath, "s_" + storedFileName));
                    try (InputStream inputStream = multipartFile.getInputStream()) {
                        Thumbnailator.createThumbnail(inputStream, thumbnail, 100, 100);
                    }
                    thumbnail.close();
                }
                attachList.add(attachVO);

            } catch (Exception e) {
                log.error("Failed to store file: " + originalFileName, e);
            }
        }

        board.setAttachList(attachList);
        board.setWriter(getLoginUser().getUserid());
        service.register(board);

        rttr.addFlashAttribute("result", board.getBno());
        return "redirect:/board/list";
    }

    // 상세
    @GetMapping("/get")
    public void get(@RequestParam("bno") Long bno,
                    @ModelAttribute("cri") Criteria cri,
                    Model model) {
        log.info("/get");
        model.addAttribute("board", service.get(bno));
        model.addAttribute("loginUser", getLoginUser());
        model.addAttribute("isLoginUserAdmin", isLoginUserAdmin());
    }

    // 첨부파일 리스트 (JSON)
    @GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<List<AttachVO>> getAttachList(Long bno) {
        log.info("getAttachList " + bno);
        return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
    }

    // 이미지 출력
    @GetMapping("/display")
    @ResponseBody
    public ResponseEntity<byte[]> getFile(String fileName) {
        log.info("fileName: " + fileName);
        String uploadFolder = "C:\\upload";
        File file = new File(uploadFolder, fileName.replace('/', File.separatorChar));

        try {
            if (!file.exists()) {
                log.error("File not found: " + file.getAbsolutePath());
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }
            HttpHeaders header = new HttpHeaders();
            header.add("Content-Type", Files.probeContentType(file.toPath()));
            return new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
        } catch (IOException e) {
            log.error("Error reading file: " + file.getAbsolutePath(), e);
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 수정 폼
    @GetMapping("/modify")
    public String modify(@RequestParam("bno") Long bno,
                         @ModelAttribute("cri") Criteria cri,
                         Model model,
                         RedirectAttributes rttr) {

        BoardVO board = service.get(bno);
        if (!isLoginUserAdmin()
                && (getLoginUser() == null
                    || !getLoginUser().getUserid().equals(board.getWriter()))) {
            rttr.addFlashAttribute("msg", "수정 권한이 없습니다.");
            return "redirect:/board/list";
        }

        log.info("/modify page");
        model.addAttribute("board", board);
        return "/board/modify";
    }

    // 수정 처리
    @PostMapping("/modify")
    public String modify(BoardVO board,
                         @RequestParam(value = "uploadFile", required = false)
                         MultipartFile[] uploadFile,
                         Criteria cri,
                         RedirectAttributes rttr) {

        log.info("modify:" + board);

        BoardVO originalBoard = service.get(board.getBno());
        if (!isLoginUserAdmin()
                && (getLoginUser() == null
                    || !getLoginUser().getUserid().equals(originalBoard.getWriter()))) {
            rttr.addFlashAttribute("msg", "수정 권한이 없습니다.");
            return "redirect:/board/list";
        }

        // 첨부파일 추가 처리
        if (uploadFile != null && uploadFile.length > 0) {
            String uploadFolder = "C:\\upload";
            String uploadFolderPath = getFolder();
            File uploadPath = new File(uploadFolder, uploadFolderPath);
            if (!uploadPath.exists()) uploadPath.mkdirs();

            if (board.getAttachList() == null) {
                board.setAttachList(new ArrayList<>());
            }

            for (MultipartFile mf : uploadFile) {
                if (mf.isEmpty()) continue;
                String originalFileName = mf.getOriginalFilename();
                if (originalFileName == null || originalFileName.trim().isEmpty()) continue;

                AttachVO attachVO = new AttachVO();
                UUID uuid = UUID.randomUUID();
                String storedFileName = uuid.toString() + "_" + originalFileName;

                try {
                    File saveFile = new File(uploadPath, storedFileName);
                    mf.transferTo(saveFile);

                    attachVO.setUuid(uuid.toString());
                    attachVO.setFileName(originalFileName);
                    attachVO.setUploadPath(uploadFolderPath);

                    if (isImage(saveFile)) {
                        attachVO.setFileType(true);
                        FileOutputStream thumbnail =
                                new FileOutputStream(new File(uploadPath, "s_" + storedFileName));
                        try (InputStream inputStream = mf.getInputStream()) {
                            Thumbnailator.createThumbnail(inputStream, thumbnail, 100, 100);
                        }
                        thumbnail.close();
                    }
                    board.getAttachList().add(attachVO);

                } catch (Exception e) {
                    log.error(e.getMessage());
                }
            }
        }

        if (service.modify(board)) {
            rttr.addFlashAttribute("result", "success");
        }
        rttr.addAttribute("page", cri.getPage());
        rttr.addAttribute("perPageNum", cri.getPerPageNum());
        return "redirect:/board/list";
    }

    // 삭제
    @PostMapping("/remove")
    public String remove(@RequestParam("bno") Long bno,
                         Criteria cri,
                         @RequestParam(value = "from", required = false) String from,
                         RedirectAttributes rttr) {

        log.info("remove..." + bno);

        BoardVO board = service.get(bno);
        if (!isLoginUserAdmin()
                && (getLoginUser() == null
                    || !getLoginUser().getUserid().equals(board.getWriter()))) {
            rttr.addFlashAttribute("msg", "삭제 권한이 없습니다.");
            return "redirect:/board/list";
        }

        List<AttachVO> attachList = service.getAttachList(bno);

        if (service.remove(bno)) {
            deleteFiles(attachList);
            rttr.addFlashAttribute("result", "success");
        }

        if ("admin".equals(from)) {
            return "redirect:/admin/main?page=" + cri.getPage()
                   + "&perPageNum=" + cri.getPerPageNum();
        }

        rttr.addAttribute("page", cri.getPage());
        rttr.addAttribute("perPageNum", cri.getPerPageNum());
        return "redirect:/board/list";
    }

    // ----------------- 파일 관련 유틸 -----------------
    private void deleteFiles(List<AttachVO> attachList) {
        if (attachList == null || attachList.isEmpty()) return;

        String uploadFolder = "C:\\upload";

        log.info("delete attach files.................");
        log.info(attachList);

        attachList.forEach(attach -> {
            try {
                File file = new File(uploadFolder,
                        attach.getUploadPath().replace("\\", File.separator)
                        + File.separator + attach.getUuid() + "_" + attach.getFileName());
                if (file.exists()) file.delete();

                if (attach.isFileType()) {
                    File thumbNail = new File(uploadFolder,
                            attach.getUploadPath().replace("\\", File.separator)
                            + File.separator + "s_" + attach.getUuid() + "_"
                            + attach.getFileName());
                    if (thumbNail.exists()) thumbNail.delete();
                }
            } catch (Exception e) {
                log.error("delete file error " + e.getMessage());
            }
        });
    }

    private String getFolder() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String str = sdf.format(new Date());
        return str.replace("-", File.separator);
    }

    private boolean isImage(File file) {
        try {
            String contentType = Files.probeContentType(file.toPath());
            return contentType != null && contentType.startsWith("image");
        } catch (IOException e) {
            log.error(e.getMessage());
        }
        return false;
    }
}
