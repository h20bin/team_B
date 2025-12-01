package org.mnu.service;

import java.util.ArrayList;
import java.util.List;
import org.mnu.domain.AttachVO;
import org.mnu.domain.BoardVO;
import org.mnu.domain.Criteria;
import org.mnu.mapper.AttachMapper;
import org.mnu.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.log4j.Log4j2;

@Log4j2
@Service
public class BoardServiceImpl implements BoardService {

    @Autowired
    private BoardMapper mapper;
    
    @Autowired
    private AttachMapper attachMapper;

    @Transactional
    @Override
    public void register(BoardVO board) {
        log.info("register......" + board);
        
        // [FIX] 얕은 복사가 아닌 깊은 복사를 통해 완전한 새 리스트를 백업합니다.
        final List<AttachVO> attachList = board.getAttachList() == null ? null : new ArrayList<>(board.getAttachList());

        // 게시물 정보를 먼저 저장합니다. 이 과정에서 board 객체의 bno가 설정됩니다.
        mapper.insert(board);
        
        if (attachList == null || attachList.size() <= 0) {
            return;
        }
        
        // 오염될 수 있는 board.getAttachList() 대신, 안전하게 백업해둔 attachList를 사용합니다.
        attachList.forEach(attach -> {
            attach.setBno(board.getBno());
            attachMapper.insert(attach);
        });
    }

    @Override
    public BoardVO get(Long bno) {
        log.info("get......" + bno);
        mapper.updateViewCnt(bno);
        BoardVO board = mapper.read(bno);
        if (board != null) {
        	board.setAttachList(attachMapper.findByBno(bno));
        }
        return board;
    }

    @Transactional
    @Override
    public boolean modify(BoardVO board) {
        log.info("modify......" + board);
        
        attachMapper.deleteAll(board.getBno());
        
        boolean modifyResult = mapper.update(board) == 1;
        
        if (modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
            board.getAttachList().forEach(attach -> {
                attach.setBno(board.getBno());
                attachMapper.insert(attach);
            });
        }
        
        return modifyResult;
    }

    @Transactional
    @Override
    public boolean remove(Long bno) {
        log.info("remove......" + bno);
        
        attachMapper.deleteAll(bno);
        
        return mapper.delete(bno) == 1;
    }

    @Override
    public List<BoardVO> getList(Criteria cri) {
        log.info("get List with criteria: " + cri);
        List<BoardVO> list = mapper.getListWithPaging(cri);
        
        // 각 게시글의 첨부파일 정보를 가져와 썸네일 필드 세팅 (N+1 문제 발생 가능하나 간단한 구현을 위해 채택)
        list.forEach(board -> {
            List<AttachVO> attachList = attachMapper.findByBno(board.getBno());
            if (attachList != null && !attachList.isEmpty()) {
                // 첫 번째 파일이 이미지라면 썸네일용으로 세팅, 아니면 그냥 정보만 세팅
                AttachVO attach = attachList.stream().filter(AttachVO::isFileType).findFirst().orElse(attachList.get(0));
                
                board.setUuid(attach.getUuid());
                // [중요] Windows 경로(\)를 웹 표준 경로(/)로 변환하여 저장
                board.setUploadPath(attach.getUploadPath().replace("\\", "/"));
                board.setFileName(attach.getFileName());
                board.setFileType(attach.isFileType());
            }
        });
        
        return list;
    }

    @Override
    public int getTotal(Criteria cri) {
        log.info("get total count");
        return mapper.getTotalCount(cri);
    }
    
    @Override
	public List<AttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno" + bno);
		return attachMapper.findByBno(bno);
	}

    @Override
    public void updateReviewStats(Long bno) {
        log.info("Updating review stats for board: " + bno);
        mapper.updateReviewStats(bno);
    }

    @Override
    public List<BoardVO> getListByWriter(Criteria cri, String writer) {
        log.info("get List by writer: " + writer);
        return mapper.getListByWriter(cri, writer);
    }

    @Override
    public int getTotalByWriter(String writer) {
        log.info("get total count by writer: " + writer);
        return mapper.getTotalCountByWriter(writer);
    }

    @Override
    public List<String> getLocations() {
        log.info("get locations");
        return mapper.getLocations();
    }
}