<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Company's Charter | MIRAE ASSET</title>
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
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Investor<br />Relations</h2>
            <ul>
                <li><a href="h05_financial.jsp">Financial Statement<br />/ Annual Report</a></li>
                <li><a href="h05_information.jsp">Information Disclosure</a></li>
                <li><a href="h05_company.jsp" class="on">Company's Charter</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Company's Charter</h3>

            <div class="search">
                <form action="">
                    <fieldset class="search_wrap">
                        <legend>Search board</legend>

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

                        <input type="submit" value="View" class="btn_search" />
                    </fieldset>
                </form>
            </div>
            <!-- // .search -->

            <div class="board">
                <table>
                    <caption>Financial Statement</caption>
                    <colgroup>
                        <col width="110" />
                        <col width="*" />
                        <col width="110" />
                        <col width="110" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">Contents</th>
                            <th scope="col">Size</th>
                            <th scope="col">Download</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>10/31/2016</td>
                            <td class="headline">
                                HNX Notice: Official Admission of additional listing of KSQ
                            </td>
                            <td>160 (KB)</td>
                            <td>
                                <a href="" class="btn_down">report download</a>
                            </td>
                        </tr>
                        <tr>
                            <td>10/31/2016</td>
                            <td class="headline">
                                2015 Macro economic review and Outlook for 2016
                            </td>
                            <td>345 (KB)</td>
                            <td>
                                <a href="" class="btn_down">report download</a>
                            </td>
                        </tr>
                        <tr>
                            <td>10/31/2016</td>
                            <td class="headline">
                                Change in shareholding of principal shareholder (Willem Stuive)
                            </td>
                            <td>56 (KB)</td>
                            <td>
                                <a href="" class="btn_down">report download</a>
                            </td>
                        </tr>
                        <tr>
                            <td>10/31/2016</td>
                            <td class="headline">
                                HNX Notice: Official Admission of additional listing of KSQ
                            </td>
                            <td>160 (KB)</td>
                            <td>
                                <a href="" class="btn_down">report download</a>
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