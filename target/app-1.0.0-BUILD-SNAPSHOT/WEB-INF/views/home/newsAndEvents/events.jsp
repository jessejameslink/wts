<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Events | MIRAE ASSET</title>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>News<br />&amp; Events</h2>
            <ul>
                <li>
                    <a href="/home/newsAndEvents/mirae.do">News</a>
                    <ul class="lnb_sub">
                        <li><a href="/home/newsAndEvents/mirae.do">Mirae Asset News</a></li>
                        <li><a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market.do')">Market News</a></li>
                    </ul>
                </li>
                <li><a href="/home/investorRelations/financial.do">Information Disclosure</a></li>
                <li><a href="/home/newsAndEvents/events.do" class="on">Events</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Events</h3>

            <div class="search">
                <form action="">
                    <fieldset class="search_wrap">
                        <legend>Search board</legend>
                        <div class="keyword">
                            <input type="text" title="keywords" class="input" />
                            <input type="submit" value="Search" class="btn_search" />
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
                    <caption>Events</caption>
                    <colgroup>
                        <col width="125" />
                        <col width="105" />
                        <col width="*" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">Time</th>
                            <th scope="col">Headline</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>10/31/2016</td>
                            <td>08:50 AM</td>
                            <td class="headline">
                                <a href="/home/newsAndEvents/mirae_view.do">HNX Notice: Official Admission of additional listing of KSQ</a>
                            </td>
                        </tr>
                        <tr>
                            <td>10/31/2016</td>
                            <td>08:50 AM</td>
                            <td class="headline">
                                <a href="/home/newsAndEvents/mirae_view.do">HNX Notice: Official Admission of additional listing of KSQ</a>
                            </td>
                        </tr>
                        <tr>
                            <td>10/31/2016</td>
                            <td>08:50 AM</td>
                            <td class="headline">
                                <a href="/home/newsAndEvents/mirae_view.do">HNX Notice: Official Admission of additional listing of KSQ</a>
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

</body>
</html>