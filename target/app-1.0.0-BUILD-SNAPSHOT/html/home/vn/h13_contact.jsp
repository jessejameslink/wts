<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Liên hệ | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/VN/css/miraeasset.css">
<script type="text/javascript" src="/resources/VN/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/VN/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/VN/js/mireaasset.js"></script>
</head>
<body>

<%@include file="header.jsp"%>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <div id="contents" class="full_width">
            <h3 class="cont_title">Liên hệ</h3>

            <div class="contact_us">
                <div class="addr">
                    <div class="hq">
                        <h4>TRỤ SỞ CHÍNH</h4>
                        <dl>
                            <dt>Địa chỉ</dt>
                            <dd>Tòa nhà Sai Gon Royal ,Tầng 7, 91 Pasteur, Quận 1, Tp. Hồ Chí Minh, Việt Nam</dd>
                            <dt>Fax</dt>
                            <dd>84-8-3-9107222</dd>
                            <dt>Tel</dt>
                            <dd>84-8-3-9102222</dd>
                            <dt>E-mail</dt>
                            <dd>contact@miraeasset.com</dd>
                        </dl>
                    </div>

                    <div class="hanoi">
                        <h4>CHI NHÁNH HÀ NỘI</h4>
                        <dl>
                            <dt>Địa chỉ</dt>
                            <dd>Tòa nhà Phương Nam Bank, lầu 4, 27 Hàng Bài, Quận Hoàn Kiếm, Hà Nội</dd>
                            <dt>Fax</dt>
                            <dd>84-4-6273-0544</dd>
                            <dt>Tel</dt>
                            <dd>84-4-6273-0541</dd>
                            <dt>E-mail</dt>
                            <dd>hanoibranch@miraeasset.com</dd>
                        </dl>
                    </div>
                </div>
                <div class="form">
                    <form>
                        <div class="form_wrap">
                            <label for="name">Họ và Tên</label>
                            <input type="text" id="name" />
                        </div>
                        <div class="form_wrap">
                            <label for="phone">Số điện thoại</label>
                            <input type="text" id="phone" />
                        </div>
                        <div class="form_wrap">
                            <label for="email">E-mail</label>
                            <input type="text" id="email" />
                        </div>
                        <div class="form_wrap">
                            <label for="cont">Nội dung</label>
                            <textarea id="cont" cols="30" rows="10"></textarea>
                        </div>
                        <div class="btn_wrap">
                            <input type="reset" value="Đóng" class="btn_reset" />
                            <input type="submit" value="Gửi" class="btn_submit" />
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>