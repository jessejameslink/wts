<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Foreigner Transaction | MIRAE ASSET</title>
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
            <h2>Investment<br />Tools</h2>
            <ul>
                <li><a href="h04_market.jsp">Market Overview</a></li>
                <li><a href="h04_price.jsp">Price history</a></li>
                <li><a href="h04_trading.jsp">Trading results</a></li>
                <li><a href="h04_foreigner.jsp" class="on">Foreigner Transaction</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Foreigner Transaction</h3>

            <div class="search">
                <form action="">
                    <fieldset class="search_wrap">
                        <legend>Search trading results</legend>

                        <div class="select">
                            <label for="market">Market</label>
                            <div class="select_wrap">
                                <select id="market">
                                    <option value="">ALL</option>
                                    <option value="">HOSE</option>
                                    <option value="">HNXSE</option>
                                    <option value="">UPCOM</option>
                                    <option value="">VSD</option>
                                </select>
                            </div>
                        </div>

                        <div class="date">
                            <label for="search_date">Date</label>
                            <span class="date_box">
                                <input type="text" id="search_date" title="search start date" class="datepicker" />
                                <button type="button">Open Calendar</button>
                            </span>
                        </div>

                        <input type="submit" value="search" class="btn_search" />
                    </fieldset>
                </form>
            </div>
            <!-- // .search -->

            <div class="price_table">
                <table>
                    <caption>Foreigner Transaction</caption>
                    <colgroup>
                        <col width="*" />
                        <col width="150" />
                        <col width="150" />
                        <col width="105" />
                        <col width="115" />
                        <col width="105" />
                        <col width="115" />
                    </colgroup>
                    <thead class="multi_row">
                        <tr>
                            <th scope="col" rowspan="2">Symbol</th>
                            <th scope="col" rowspan="2">Total Room</th>
                            <th scope="col" rowspan="2">Current Room</th>
                            <th scope="colgroup" colspan="2">Buy</th>
                            <th scope="colgroup" colspan="2">Sell</th>
                        </tr>
                        <tr>
                            <th scope="col">Bid Volume</th>
                            <th scope="col">Value</th>
                            <th scope="col">Ask Volume</th>
                            <th scope="col">Value</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="center">AAA</td>
                            <td>14,125,917</td>
                            <td>25,985,000</td>
                            <td>1,604.6</td>
                            <td class="dot_bd">2,409.3</td>
                            <td>536,457</td>
                            <td class="dot_bd">4,925,985,000</td>
                        </tr>
                        <tr>
                            <td class="center">CAB</td>
                            <td>14,125,917</td>
                            <td>25,985,000</td>
                            <td>1,604.6</td>
                            <td class="dot_bd">2,409.3</td>
                            <td>536,457</td>
                            <td class="dot_bd">25,985,000</td>
                        </tr>
                        <tr>
                            <td class="center">AAC</td>
                            <td>4,925,985,000</td>
                            <td>25,985,000</td>
                            <td>1,604.6</td>
                            <td class="dot_bd">2,409.3</td>
                            <td>536,457</td>
                            <td class="dot_bd">1,925,985,000</td>
                        </tr>
                        <tr>
                            <td class="center">BAA</td>
                            <td>14,125,917</td>
                            <td>25,985,000</td>
                            <td>1,604.6</td>
                            <td class="dot_bd">2,409.3</td>
                            <td>536,457</td>
                            <td class="dot_bd">25,985,000</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- // .price_table -->

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