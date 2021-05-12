<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Công bố thông tin | MIRAE ASSET</title>
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
            <h2>QUAN HỆ<br />NHÀ ĐẦU TƯ</h2>
            <ul>
                <li><a href="h05_financial.jsp">Báo cáo tài chính<br />/ Báo cáo thường niên</a></li>
                <li><a href="h05_information.jsp" class="on">Công bố thông tin</a></li>
                <li><a href="h05_company.jsp">Điều lệ công ty</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Công bố thông tin</h3>

            <div class="board">
                <table>
                    <caption>Information</caption>
                    <colgroup>
                        <col width="125" />
                        <col width="105" />
                        <col width="*" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Ngày</th>
                            <th scope="col">Thời gian</th>
                            <th scope="col">Tên văn bản</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>10/31/2016</td>
                            <td>08:50 AM</td>
                            <td class="headline">
                                HNX Notice: Official Admission of additional listing of KSQ
                            </td>
                        </tr>
                        <tr>
                            <td>10/31/2016</td>
                            <td>08:50 AM</td>
                            <td class="headline">
                                HNX Notice: Official Admission of additional listing of KSQ
                            </td>
                        </tr>
                        <tr>
                            <td>10/31/2016</td>
                            <td>08:50 AM</td>
                            <td class="headline">
                                HNX Notice: Official Admission of additional listing of KSQ
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- // .board -->

            <div class="pagination">
                <a href="" class="first"></a>
                <a href="" class="prev"></a>
                <a href="">1</a>
                <a href="">2</a>
                <a href="" class="current">3</a>
                <a href="">4</a>
                <a href="">5</a>
                <a href="">6</a>
                <a href="">7</a>
                <a href="">8</a>
                <a href="">9</a>
                <a href="">10</a>
                <a href="" class="next"></a>
                <a href="" class="last"></a>
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