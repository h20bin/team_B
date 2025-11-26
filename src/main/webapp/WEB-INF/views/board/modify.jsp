<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>물품 수정 - 체육시설 조회</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 1. 기본 스타일 */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; }
        body { display: flex; flex-direction: column; align-items: center; color: #212529; background-color: #fff; }
        a { text-decoration: none; color: inherit; transition: 0.2s; }
        
        header { width: 100%; height: 64px; display: flex; justify-content: center; align-items: center; position: fixed; top: 0; left: 0; background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); z-index: 100; border-bottom: 1px solid #f1f3f5; }
        .logo { color: #212529; font-size: 22px; font-weight: 800; display: flex; align-items: center; gap: 8px; letter-spacing: -0.5px; }
        .logo i { color: #339af0; font-size: 24px; }

        .main-container { margin-top: 100px; width: 100%; max-width: 800px; padding: 40px 20px; padding-bottom: 80px; }
        h1 { font-size: 32px; font-weight: 800; margin-bottom: 40px; text-align: center; color: #212529; letter-spacing: -1px; }

        .form-group { margin-bottom: 30px; }
        .form-label { display: block; font-size: 16px; font-weight: 700; margin-bottom: 12px; color: #495057; }
        .form-label i { margin-right: 6px; color: #339af0; width: 20px; text-align: center; }

        .form-input { width: 100%; padding: 14px; border: 1px solid #dee2e6; border-radius: 8px; font-size: 16px; color: #212529; transition: 0.2s; outline: none; background-color: #fff; }
        .form-input:focus { border-color: #339af0; box-shadow: 0 0 0 3px rgba(51, 154, 240, 0.1); }
        .form-input[readonly] { background-color: #f8f9fa; color: #868e96; cursor: default; }

        /* 이미지 업로드 영역 */
        .file-upload-wrapper {
            display: flex; flex-direction: column; gap: 15px;
        }
        
        /* 기존 파일 표시 영역 */
        .uploadResult ul {
            display: flex; flex-wrap: wrap; gap: 10px; list-style: none; padding: 0;
        }
        .uploadResult ul li {
            position: relative; width: 100px; height: 100px; border-radius: 8px; overflow: hidden;
            border: 1px solid #dee2e6;
        }
        .uploadResult ul li img {
            width: 100%; height: 100%; object-fit: cover;
        }
        .uploadResult ul li .btn-del-img {
            position: absolute; top: 0; right: 0; background: rgba(255,0,0,0.7); color: white; border: none;
            width: 25px; height: 25px; cursor: pointer; display: flex; justify-content: center; align-items: center;
        }

        /* 새 파일 추가 버튼 */
        .image-preview-box {
            width: 100%; height: 50px;
            border: 2px dashed #dee2e6; border-radius: 8px;
            display: flex; justify-content: center; align-items: center;
            cursor: pointer; color: #adb5bd; transition: all 0.2s;
        }
        .image-preview-box:hover { border-color: #339af0; color: #339af0; background-color: #f8f9fa; }
        .image-preview-box i { margin-right: 8px; }

        .btn-area { display: flex; justify-content: space-between; align-items: center; margin-top: 50px; padding-top: 20px; border-top: 1px solid #e9ecef; }
        .btn-right { display: flex; gap: 10px; }
        .btn { display: inline-flex; justify-content: center; align-items: center; gap: 6px; padding: 12px 24px; border-radius: 8px; font-size: 16px; font-weight: 700; cursor: pointer; border: none; transition: all 0.2s; }
        
        .btn-list { background-color: #f1f3f5; color: #495057; }
        .btn-list:hover { background-color: #e9ecef; }
        .btn-cancel { background-color: white; border: 1px solid #dee2e6; color: #495057; }
        .btn-cancel:hover { background-color: #f8f9fa; border-color: #adb5bd; }
        .btn-save { background: linear-gradient(135deg, #339af0 0%, #228be6 100%); color: white; }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 4px 10px rgba(34, 139, 230, 0.3); }
    </style>
</head>
<body>

    <header>
        <div class="logo"><i class="fa-solid fa-dumbbell"></i> 체육시설 조회</div>
    </header>

    <div class="main-container">
        <h1>물품 정보 수정</h1>

        <form role="form" action="/board/modify" method="post" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="page" value="<c:out value='${cri.page}'/>">
            <input type="hidden" name="perPageNum" value="<c:out value='${cri.perPageNum}'/>">
            <input type="hidden" name="bno" value="<c:out value='${board.bno}'/>">

            <div class="form-group">
                <label class="form-label"><i class="fa-regular fa-image"></i> 이미지 수정</label>
                <div class="file-upload-wrapper">
                    <div class="uploadResult">
                        <ul></ul>
                    </div>
                    
                    <input type="file" id="fileInput" name="uploadFile" style="display: none;" accept="image/*">
                    <div class="image-preview-box" onclick="document.getElementById('fileInput').click()">
                        <i class="fa-solid fa-camera"></i> <span>새로운 사진 추가하기 (선택 시 기존 사진 유지)</span>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label"><i class="fa-solid fa-tag"></i> 물품 이름</label>
                <input type="text" name="title" class="form-input" value="<c:out value='${board.title}'/>" required>
            </div>

            <div class="form-group">
                <label class="form-label"><i class="fa-solid fa-heart-pulse"></i> 물건 상태</label>
                <input type="text" name="content" class="form-input" value="<c:out value='${board.content}'/>" required>
            </div>

			<div class="form-group">
                <label class="form-label"><i class="fa-solid fa-map-location-dot"></i> 대여 장소</label>
                <input type="text" name="location" class="form-input" value="<c:out value='${board.location}'/>" placeholder="대여 장소를 입력하세요">
            </div>

            <div class="form-group">
                <label class="form-label"><i class="fa-solid fa-user"></i> 작성자</label>
                <input type="text" name="writer" class="form-input" value="<c:out value='${board.writer}'/>" readonly>
            </div>

            <div class="btn-area">
                <a href="/board/list?page=<c:out value='${cri.page}'/>&perPageNum=<c:out value='${cri.perPageNum}'/>" class="btn btn-list">
                    <i class="fa-solid fa-list"></i> 목록
                </a>

                <div class="btn-right">
                    <a href="/board/get?bno=<c:out value='${board.bno}'/>&page=<c:out value='${cri.page}'/>&perPageNum=<c:out value='${cri.perPageNum}'/>" class="btn btn-cancel">
                        취소
                    </a>
                    <button type="submit" class="btn btn-save">
                        <i class="fa-solid fa-check"></i> 수정 완료
                    </button>
                </div>
            </div>
        </form>

    </div>

    <script>
        // 페이지 로드 시 기존 첨부파일 가져오기
        (function() {
            var bno = '<c:out value="${board.bno}"/>';
            var uploadResult = document.querySelector(".uploadResult ul");

            fetch('/board/getAttachList?bno=' + bno)
                .then(response => response.json())
                .then(data => {
                    var str = "";
                    data.forEach(function(attach) {
                        // 경로 처리 (역슬래시 -> 슬래시)
                        var uploadPath = attach.uploadPath.replace(/\\/g, "/");
                        var fileCallPath = encodeURIComponent(uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
                        
                        str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>";
                        str += "   <img src='/board/display?fileName=" + fileCallPath + "'>";
                        // x버튼 (구현은 백엔드 로직이 복잡해지므로 일단 UI만 표시)
                        str += "</li>";
                    });
                    uploadResult.innerHTML = str;
                })
                .catch(err => console.log(err));
        })();
        
        // 새 파일 선택 시 알림
        document.getElementById("fileInput").addEventListener("change", function(){
            if(this.files && this.files.length > 0){
                alert(this.files.length + "개의 파일이 선택되었습니다. '수정 완료'를 누르면 저장됩니다.");
            }
        });
    </script>

</body>
</html>