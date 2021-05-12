<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Contact Us | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/US/css/miraeasset.css">
<script type="text/javascript" src="/resources/US/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/js/mireaasset.js"></script>
</head>
<body>

<%@include file="header.jsp"%>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <div id="contents" class="full_width">
            <h3 class="cont_title">Contact Us</h3>

            <div class="contact_us">
                <div class="addr">
                    <div class="hq">
                        <h4>HEADQUARTER</h4>
                        <dl>
                            <dt>Address</dt>
                            <dd>7th Floor, Sai Gon Royal building, 91 Pasteur street,<br />Ben Nghe Ward, District 1, Ho Chi Minh</dd>
                            <dt>Fax</dt>
                            <dd>84-8-3-9107222</dd>
                            <dt>Tel</dt>
                            <dd>84-8-3-9102222</dd>
                            <dt>E-mail</dt>
                            <dd>contact@miraeasset.com</dd>
                        </dl>
                    </div>

                    <div class="hanoi">
                        <h4>HA NOI BRANCH</h4>
                        <dl>
                            <dt>Address</dt>
                            <dd>4th Floor, Phuong Nam Bank building, 27 Hang Bai<br />street, Hoan Kiem District, Ha Noi</dd>
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
                            <label for="name">Full name</label>
                            <input type="text" id="name" />
                        </div>
                        <div class="form_wrap">
                            <label for="phone">Phone number</label>
                            <input type="text" id="phone" />
                        </div>
                        <div class="form_wrap">
                            <label for="email">E-mail</label>
                            <input type="text" id="email" />
                        </div>
                        <div class="form_wrap">
                            <label for="cont">Content</label>
                            <textarea id="cont" cols="30" rows="10"></textarea>
                        </div>
                        <div class="btn_wrap">
                            <input type="reset" value="cancel" class="btn_reset" />
                            <input type="submit" value="Send" class="btn_submit" />
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