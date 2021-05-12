<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Tin MIRAE ASSET | MIRAE ASSET</title>
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
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Tin tức<br />&amp; Sự kiện</h2>
            <ul>
                <li>
                    <a href="h03_mirae.jsp" class="on">Tin tức</a>
                    <ul class="lnb_sub">
                        <li><a href="h03_mirae.jsp" class="on">Tin MIRAE ASSET</a></li>
                        <li><a href="h03_market.jsp">Tin Thị trường</a></li>
                    </ul>
                </li>
                <li><a href="h03_Sự kiện.jsp">Sự kiện</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Tin MIRAE ASSET</h3>

            <div class="board_view">
                <div class="header">
                    <p class="date">10/31/2016</p>
                    <p class="time">08:50 AM</p>
                    <h4>HNX Notice: Official Admission of additional listing of KSQ</h4>
                </div>
                <div class="body">

                    <!-- 더미데이터 -->
                    <p style="font-size:16px; line-height:26px; font-weight:700;">NOTICE<br />
                        (Ref: Lunar New Year 2016 holiday)</p>
                    <p style="margin-top:40px;">
                        Dear Investors,<br />
                        MIRAE ASSET Quản lý tài sản Securities (Việt Nam) Liability Limited Company would like to send our sincere thanks to your enthusiastic Hỗ trợ to our Company.
                        As announced by the Hochiminh Stock ExXác nhận and the Hanoi Stock ExXác nhận, we are pleased to inform you that the securities market will be closed from Monday 8th February 2016 to the end of Friday 12th February 2016. The trading activities will be arranged as usual from Monday, 15th February 2016<br />
                        <br />
                        Sincerely yours,
                    </p>
                    <!-- // 더미데이터 -->

                </div>
                <div class="rel">
                    <p class="pre">
                        <span class="head">Pre</span>
                        <span class="date">10/31/2016</span>
                        <span class="time">08:50 AM</span>
                        <span class="title">
                            <a href="">MHC: MHC withdraws capital in a member company</a>
                        </span>
                    </p>
                    <p class="next">
                        <span class="head">Next</span>
                        <span class="date">10/31/2016</span>
                        <span class="time">08:50 AM</span>
                        <span class="title">
                            <a href="">MHC: MHC withdraws capital in a member company</a>
                        </span>
                    </p>
                </div>
            </div>
            
            <div class="bottom_btns">
                <a href="" class="btn">LIST</a>
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