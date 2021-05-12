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
                <li><a href="h03_events.jsp">Sự kiện</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Tin MIRAE ASSET</h3>

            <div class="search">
                <form action="">
                    <fieldset class="search_wrap">
                        <legend>Search board</legend>
                        <div class="keyword">
                            <input type="text" title="keywords" class="input" />
                            <input type="submit" value="TÌm kiếm" class="btn_search" />
                        </div>

                        <div class="date">
                            <span class="date_box">
                                <input type="text" title="search start date" class="datepicker" />
                                <button type="button">Open Calendar</button>
                            </span>
                            <span class="tide">~</span>
                            <span class="date_box">
                                <input type="text" title="search end date" class="datepicker" />
                                <button type="button">Open Calendar</button>
                            </span>
                        </div>
                    </fieldset>
                </form>
            </div>
            <!-- // .search -->

            <div class="board">
                <table>
                    <caption>Tin MIRAE ASSET</caption>
                    <colgroup>
                        <col width="125" />
                        <col width="105" />
                        <col width="*" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Ngày</th>
                            <th scope="col">Thời gian</th>
                            <th scope="col">Tin nổi bật</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>10/31/2016</td>
                            <td>08:50 AM</td>
                            <td class="headline">
                                <a href="h03_mirae_view.jsp">HNX Notice: Official Admission of additional listing of KSQ</a>
                            </td>
                        </tr>
                        <tr>
                            <td>10/31/2016</td>
                            <td>08:50 AM</td>
                            <td class="headline">
                                <a href="h03_mirae_view.jsp">HNX Notice: Official Admission of additional listing of KSQ</a>
                            </td>
                        </tr>
                        <tr>
                            <td>10/31/2016</td>
                            <td>08:50 AM</td>
                            <td class="headline">
                                <a href="h03_mirae_view.jsp">HNX Notice: Official Admission of additional listing of KSQ</a>
                            </td>
                        </tr>
                        <!-- 조회 결과가 없을경우 -->
                        <tr>
                            <td class="no_result" colspan="3">No results found</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- // .board -->

            <!-- <a href="" class="btn_more">MORE (20)</a> -->

            <div class="page_nav">
                <a href="" class="prev">Prev</a>
                <a href="" class="next">Next</a>
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