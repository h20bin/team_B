<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>물품 등록 - 체육시설 조회</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 1. 기본 설정 */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; }
        body { display: flex; flex-direction: column; align-items: center; color: #212529; background-color: #fff; }
        a { text-decoration: none; color: inherit; transition: 0.2s; }
        
        /* 2. 헤더 */
        header { width: 100%; height: 64px; display: flex; justify-content: center; align-items: center; position: fixed; top: 0; left: 0; background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); z-index: 100; border-bottom: 1px solid #f1f3f5; }
        .logo { color: #212529; font-size: 22px; font-weight: 800; display: flex; align-items: center; gap: 8px; letter-spacing: -0.5px; }
        .logo i { color: #339af0; font-size: 24px; }

        /* 3. 메인 컨테이너 */
        .main-container { margin-top: 100px; width: 100%; max-width: 800px; padding: 40px 20px; padding-bottom: 80px; }
        h1 { font-size: 32px; font-weight: 800; margin-bottom: 40px; text-align: center; color: #212529; letter-spacing: -1px; }

        /* 4. 폼 디자인 */
        .form-group { margin-bottom: 30px; }
        .form-label { display: block; font-size: 16px; font-weight: 700; margin-bottom: 12px; color: #495057; }
        .form-label i { margin-right: 6px; color: #339af0; width: 20px; text-align: center; }

        .form-input { width: 100%; padding: 14px; border: 1px solid #dee2e6; border-radius: 8px; font-size: 16px; color: #212529; transition: 0.2s; outline: none; background-color: #fff; }
        .form-input:focus { border-color: #339af0; box-shadow: 0 0 0 3px rgba(51, 154, 240, 0.1); }

        /* 이미지 업로드 영역 */
        .image-upload-container { display: flex; flex-wrap: wrap; gap: 15px; }
        .upload-box { width: 150px; height: 150px; border: 2px dashed #dee2e6; border-radius: 12px; display: flex; flex-direction: column; justify-content: center; align-items: center; cursor: pointer; color: #adb5bd; transition: all 0.2s; }
        .upload-box:hover { border-color: #339af0; color: #339af0; background-color: #f8f9fa; }
        .upload-box i { font-size: 32px; margin-bottom: 8px; }
        .upload-box span { font-size: 14px; font-weight: 600; text-align: center; }
        
        .preview-item { position: relative; width: 150px; height: 150px; border-radius: 12px; overflow: hidden; border: 1px solid #e9ecef; }
        .preview-item img { width: 100%; height: 100%; object-fit: cover; }
        .remove-btn { position: absolute; top: 5px; right: 5px; width: 24px; height: 24px; background-color: rgba(0,0,0,0.5); color: white; border: none; border-radius: 50%; display: flex; justify-content: center; align-items: center; cursor: pointer; font-size: 14px; font-weight: bold; line-height: 1; transition: background-color 0.2s; }
        .remove-btn:hover { background-color: rgba(250, 82, 82, 0.8); }

        /* 5. 버튼 영역 */
        .btn-area { display: flex; justify-content: space-between; align-items: center; margin-top: 50px; padding-top: 20px; border-top: 1px solid #e9ecef; }
        .btn-right { display: flex; gap: 10px; }
        .btn { display: inline-flex; justify-content: center; align-items: center; gap: 6px; padding: 12px 24px; border-radius: 8px; font-size: 16px; font-weight: 700; cursor: pointer; border: none; transition: all 0.2s; }
        .btn-list { background-color: #f1f3f5; color: #495057; }
        .btn-list:hover { background-color: #e9ecef; }
        .btn-reset { background-color: white; border: 1px solid #dee2e6; color: #fa5252; }
        .btn-reset:hover { background-color: #fff5f5; border-color: #ffc9c9; }
        .btn-submit { background: linear-gradient(135deg, #339af0 0%, #228be6 100%); color: white; }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 4px 10px rgba(34, 139, 230, 0.3); }

    </style>
</head>
<body>

    <header>
        <div class="logo"><i class="fa-solid fa-dumbbell"></i> 체육시설 조회</div>
    </header>

    <div class="main-container">
        <h1>물품 등록</h1>

        <form id="registerForm">
            
            <div class="form-group">
                <label class="form-label"><i class="fa-regular fa-image"></i> 이미지 (총 4장 등록가능)</label>
                <div class="image-upload-container" id="imageContainer">
                    <input type="file" id="fileInput" style="display: none;" accept="image/*" multiple onchange="handleFiles(this.files)">
                    
                    <div class="upload-box" id="uploadBox" onclick="document.getElementById('fileInput').click()">
                        <i class="fa-solid fa-camera"></i>
                        <span>사진 등록</span>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label"><i class="fa-solid fa-tag"></i> 물품 이름</label>
                <input type="text" id="title" class="form-input" placeholder="물품 이름을 입력해주세요">
            </div>

            <div class="form-group">
                <label class="form-label"><i class="fa-solid fa-align-left"></i> 설명</label>
                <textarea id="content" class="form-input" style="min-height: 200px; resize: vertical;" placeholder="물건 설명, 상태 등을 입력하세요"></textarea>
            </div>

            <div class="form-group">
                <label class="form-label"><i class="fa-solid fa-map-location-dot"></i> 대여 장소</label>
                <input type="text" id="location" class="form-input" placeholder="대여 가능한 장소를 입력해주세요">
            </div>

            <div class="btn-area">
                <a href="/board/list" class="btn btn-list"><i class="fa-solid fa-list"></i> 목록</a>
                <div class="btn-right">
                    <button type="button" class="btn btn-reset" onclick="resetForm()"><i class="fa-solid fa-rotate-left"></i> 초기화</button>
                    <button type="button" id="submitBtn" class="btn btn-submit"><i class="fa-solid fa-paper-plane"></i> 등록</button>
                </div>
            </div>
        </form>
    </div>

 <script>
        // [핵심] 선택된 파일들을 관리할 배열
        let selectedFiles = [];
        const MAX_IMAGES = 4; // 최대 이미지 개수 제한

        // 1. 파일 선택 핸들러
        function handleFiles(files) {
            const newFiles = Array.from(files); // FileList -> Array 변환
            
            // 이미지 파일만 걸러내기
            const validFiles = newFiles.filter(file => file.type.startsWith('image/'));

            // [추가된 로직] 개수 제한 체크
            if (selectedFiles.length + validFiles.length > MAX_IMAGES) {
                alert('이미지는 최대 ' + MAX_IMAGES + '장까지만 등록할 수 있습니다.');
                document.getElementById('fileInput').value = ''; // input 초기화
                return; // 추가하지 않고 함수 종료
            }
            
            // 제한을 넘지 않으면 배열에 추가
            validFiles.forEach(file => {
                selectedFiles.push(file); 
            });

            renderPreviews(); // 화면 갱신
            document.getElementById('fileInput').value = ''; // input 초기화
        }
        
        // 2. 미리보기 렌더링
        function renderPreviews() {
            const imageContainer = document.getElementById('imageContainer');
            const uploadBox = document.getElementById('uploadBox');
            
            // [추가] 업로드 버튼 텍스트 갱신 (예: 사진 등록 2/4)
            const countText = selectedFiles.length + '/' + MAX_IMAGES;
            uploadBox.querySelector('span').innerText = '사진 등록 (' + countText + ')';

            // [추가] 4장이 꽉 차면 업로드 버튼 숨기기 (선택 사항)
            if (selectedFiles.length >= MAX_IMAGES) {
                uploadBox.style.display = 'none';
            } else {
                uploadBox.style.display = 'flex';
            }

            // 기존 미리보기 삭제 (uploadBox만 남기고 다 지움)
            const existingPreviews = imageContainer.querySelectorAll('.preview-item');
            existingPreviews.forEach(item => item.remove());

            // 배열에 있는 파일들로 다시 그림
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
                    
                    // 삭제 로직
                    removeBtn.onclick = () => {
                        selectedFiles.splice(index, 1); // 배열에서 삭제
                        renderPreviews(); // 화면 다시 그리기 (인덱스 재정렬됨)
                    };

                    previewItem.appendChild(img);
                    previewItem.appendChild(removeBtn);
                    
                    // uploadBox 앞에 삽입
                    imageContainer.insertBefore(previewItem, uploadBox);
                };
                reader.readAsDataURL(file);
            });
        }

        // 3. 초기화
        function resetForm() {
            document.getElementById("registerForm").reset();
            selectedFiles = [];
            renderPreviews();
        }

        // 4. 폼 전송 (AJAX) - 기존과 동일
        document.getElementById('submitBtn').addEventListener('click', async function() {
            const title = document.getElementById("title");
            const content = document.getElementById("content");

            if (title.value.trim() === "") {
                alert("물품 이름을 입력해주세요.");
                title.focus();
                return;
            }
            if (content.value.trim() === "") {
                alert("물건 설명을 입력해주세요.");
                content.focus();
                return;
            }

            const formData = new FormData();
            formData.append('title', title.value);
            formData.append('content', content.value);
            formData.append('location', document.getElementById('location').value);
            
            const csrfToken = "${_csrf.token}";
            formData.append("${_csrf.parameterName}", csrfToken);

            if (selectedFiles.length > 0) {
                selectedFiles.forEach(file => {
                    formData.append('uploadFile', file);
                });
            }

            const btn = this;
            btn.disabled = true;
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> 등록 중...';

            try {
                const response = await fetch('/board/register', {
                    method: 'POST',
                    body: formData
                });

                if (response.redirected) {
                    window.location.href = response.url;
                } else if (response.ok) {
                    window.location.href = '/board/list';
                } else {
                    throw new Error('Server Error');
                }
            } catch (error) {
                console.error('Error:', error);
                alert('등록 중 오류가 발생했습니다.');
                btn.disabled = false;
                btn.innerHTML = '<i class="fa-solid fa-paper-plane"></i> 등록';
            }
        });
    </script>

</body>
</html>