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

        /* 이미지 업로드 영역 (register.jsp 스타일) */
        .image-upload-container { display: flex; flex-wrap: wrap; gap: 15px; }
        .upload-box { width: 150px; height: 150px; border: 2px dashed #dee2e6; border-radius: 12px; display: flex; flex-direction: column; justify-content: center; align-items: center; cursor: pointer; color: #adb5bd; transition: all 0.2s; }
        .upload-box:hover { border-color: #339af0; color: #339af0; background-color: #f8f9fa; }
        .upload-box i { font-size: 32px; margin-bottom: 8px; }
        .upload-box span { font-size: 14px; font-weight: 600; text-align: center; }
        
        .preview-item { position: relative; width: 150px; height: 150px; border-radius: 12px; overflow: hidden; border: 1px solid #e9ecef; }
        .preview-item img { width: 100%; height: 100%; object-fit: cover; }
        .remove-btn { position: absolute; top: 5px; right: 5px; width: 24px; height: 24px; background-color: rgba(0,0,0,0.5); color: white; border: none; border-radius: 50%; display: flex; justify-content: center; align-items: center; cursor: pointer; font-size: 14px; font-weight: bold; line-height: 1; transition: background-color 0.2s; }
        .remove-btn:hover { background-color: rgba(250, 82, 82, 0.8); }

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
    <!-- Daum Postcode Service -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>

    <header>
        <div class="logo"><i class="fa-solid fa-dumbbell"></i> 짐빌려</div>
    </header>

    <div class="main-container">
        <h1>물품 정보 수정</h1>

        <!-- form에 id 추가, enctype 유지 -->
        <form id="modifyForm" role="form" action="/board/modify" method="post" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="page" value="<c:out value='${cri.page}'/>">
            <input type="hidden" name="perPageNum" value="<c:out value='${cri.perPageNum}'/>">
            <input type="hidden" name="bno" value="<c:out value='${board.bno}'/>">

            <!-- 이미지 업로드 UI (register.jsp와 통일) -->
            <div class="form-group">
                <label class="form-label"><i class="fa-regular fa-image"></i> 이미지 수정 (총 4장)</label>
                <div class="image-upload-container" id="imageContainer">
                    <input type="file" id="fileInput" name="uploadFile" style="display: none;" accept="image/*" multiple onchange="handleFiles(this.files)">
                    
                    <div class="upload-box" id="uploadBox" onclick="document.getElementById('fileInput').click()">
                        <i class="fa-solid fa-camera"></i>
                        <span>사진 추가</span>
                    </div>
                </div>
            </div>
            
            <!-- 카테고리 수정 추가 -->
            <div class="form-group">
                <label class="form-label"><i class="fa-solid fa-filter"></i> 카테고리</label>
                <div style="display:flex; gap:20px; align-items:center;">
                    <label style="display:flex; align-items:center; gap:5px; cursor:pointer; font-size:16px;">
                        <input type="radio" name="category" value="facility" style="width:18px; height:18px; accent-color:#339af0;" <c:if test="${board.category == 'facility'}">checked</c:if>> 체육시설
                    </label>
                    <label style="display:flex; align-items:center; gap:5px; cursor:pointer; font-size:16px;">
                        <input type="radio" name="category" value="goods" style="width:18px; height:18px; accent-color:#339af0;" <c:if test="${board.category == 'goods'}">checked</c:if>> 체육용품
                    </label>
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
                <input type="text" id="location" name="location" class="form-input" value="<c:out value='${board.location}'/>" placeholder="클릭하여 주소를 검색하세요" readonly onclick="execDaumPostcode()">
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
        // Daum Postcode Function
        function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    var addr = '';
                    if (data.userSelectedType === 'R') {
                        addr = data.roadAddress;
                    } else {
                        addr = data.jibunAddress;
                    }
                    document.getElementById("location").value = addr;
                }
            }).open();
        }
        
        // --- 첨부파일 관리 로직 ---
        let selectedFiles = []; // 새로 추가된 파일 객체들
        let oldFiles = []; // 기존 파일 객체들 (DB에서 불러온 것)
        const MAX_IMAGES = 4;

        // 1. 페이지 로드 시 기존 파일 불러오기
        (function() {
            var bno = '<c:out value="${board.bno}"/>';
            fetch('/board/getAttachList?bno=' + bno)
                .then(response => response.json())
                .then(data => {
                    oldFiles = data; // 기존 파일 데이터 저장
                    renderPreviews();
                })
                .catch(err => console.log(err));
        })();

        // 2. 새 파일 선택 핸들러
        function handleFiles(files) {
            const newFiles = Array.from(files);
            const validFiles = newFiles.filter(file => file.type.startsWith('image/'));

            // 전체 개수 체크 (기존 + 새파일)
            if (oldFiles.length + selectedFiles.length + validFiles.length > MAX_IMAGES) {
                alert('이미지는 최대 ' + MAX_IMAGES + '장까지만 등록할 수 있습니다.');
                document.getElementById('fileInput').value = '';
                return;
            }
            
            validFiles.forEach(file => {
                selectedFiles.push(file);
            });
            renderPreviews();
            document.getElementById('fileInput').value = '';
        }

        // 3. 미리보기 렌더링 (기존 + 새파일 통합)
        function renderPreviews() {
            const imageContainer = document.getElementById('imageContainer');
            const uploadBox = document.getElementById('uploadBox');
            
            // 업로드 버튼 텍스트 갱신
            const totalCount = oldFiles.length + selectedFiles.length;
            uploadBox.querySelector('span').innerText = '사진 추가 (' + totalCount + '/' + MAX_IMAGES + ')';

            if (totalCount >= MAX_IMAGES) {
                uploadBox.style.display = 'none';
            } else {
                uploadBox.style.display = 'flex';
            }

            // 기존 미리보기 삭제 (uploadBox 제외)
            const existingPreviews = imageContainer.querySelectorAll('.preview-item');
            existingPreviews.forEach(item => item.remove());

            // A. 기존 파일 렌더링
            oldFiles.forEach((file, index) => {
                const previewItem = document.createElement('div');
                previewItem.className = 'preview-item';
                
                // 경로 처리
                const uploadPath = file.uploadPath.replace(/\\/g, "/");
                const fileCallPath = encodeURIComponent(uploadPath + "/s_" + file.uuid + "_" + file.fileName);
                
                const img = document.createElement('img');
                img.src = '/board/display?fileName=' + fileCallPath;
                
                const removeBtn = document.createElement('button');
                removeBtn.className = 'remove-btn';
                removeBtn.innerHTML = '×';
                removeBtn.type = 'button';
                removeBtn.onclick = () => {
                    oldFiles.splice(index, 1);
                    renderPreviews();
                };

                previewItem.appendChild(img);
                previewItem.appendChild(removeBtn);
                imageContainer.insertBefore(previewItem, uploadBox);
            });

            // B. 새 파일 렌더링
            selectedFiles.forEach((file, index) => {
                const reader = new FileReader();
                reader.onload = e => {
                    const previewItem = document.createElement('div');
                    previewItem.className = 'preview-item';
                    
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    
                    const removeBtn = document.createElement('button');
                    removeBtn.className = 'remove-btn';
                    removeBtn.innerHTML = '×';
                    removeBtn.type = 'button';
                    removeBtn.onclick = () => {
                        selectedFiles.splice(index, 1);
                        renderPreviews();
                    };

                    previewItem.appendChild(img);
                    previewItem.appendChild(removeBtn);
                    imageContainer.insertBefore(previewItem, uploadBox);
                };
                reader.readAsDataURL(file);
            });
        }

        // 4. 폼 전송 처리
        document.querySelector(".btn-save").addEventListener("click", function(e){
            e.preventDefault();
            const form = document.getElementById("modifyForm");
            
            // 기존 파일 정보 hidden input 생성
            // 서버에서 attachList[i].uuid 형태로 받으려면 인덱싱이 필요함
            // BoardVO의 attachList는 List<AttachVO> 타입
            oldFiles.forEach((file, i) => {
                let inputUuid = document.createElement("input");
                inputUuid.type = "hidden";
                inputUuid.name = "attachList[" + i + "].uuid";
                inputUuid.value = file.uuid;
                
                let inputPath = document.createElement("input");
                inputPath.type = "hidden";
                inputPath.name = "attachList[" + i + "].uploadPath";
                inputPath.value = file.uploadPath;
                
                let inputName = document.createElement("input");
                inputName.type = "hidden";
                inputName.name = "attachList[" + i + "].fileName";
                inputName.value = file.fileName;
                
                let inputType = document.createElement("input");
                inputType.type = "hidden";
                inputType.name = "attachList[" + i + "].fileType";
                inputType.value = file.fileType;
                
                form.appendChild(inputUuid);
                form.appendChild(inputPath);
                form.appendChild(inputName);
                form.appendChild(inputType);
            });

            // 새 파일 전송을 위해 DataTransfer 사용 (input type=file에 파일 심기)
            if (selectedFiles.length > 0) {
                const dataTransfer = new DataTransfer();
                selectedFiles.forEach(file => dataTransfer.items.add(file));
                document.getElementById("fileInput").files = dataTransfer.files;
            }
            
            // input type=file은 form 안에 이미 존재하므로(name='uploadFile') 
            // 위에서 files를 채워주면 자동으로 전송됨.
            // 단, fileInput의 name을 'uploadFile'로 맞춰야 함. (현재 코드 상 name='uploadFile' 확인됨)

            form.submit();
        });
    </script>

</body>
</html>