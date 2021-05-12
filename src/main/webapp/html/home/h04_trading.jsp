<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Trading results | MIRAE ASSET</title>
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
                <li><a href="h04_trading.jsp" class="on">Trading results</a></li>
                <li><a href="h04_foreigner.jsp">Foreigner Transaction</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Trading results</h3>

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
                        <button type="button" class="btn_down">download</button>
                    </fieldset>
                </form>
            </div>
            <!-- // .search -->

            <div class="price_table">
                <table>
                    <caption>Trading Results</caption>
                    <colgroup>
                        <col width="60" />
                        <col width="65" />
                        <col width="60" />
                        <col width="80" />
                        <col width="60" />
                        <col width="80" />
                        <col width="75" />
                        <col width="75" />
                        <col width="75" />
                        <col width="75" />
                        <col width="*" />
                    </colgroup>
                    <thead class="multi_row">
                        <tr>
                            <th scope="col" rowspan="2">Symbol</th>
                            <th scope="col" rowspan="2">Close<br />Price</th>
                            <th scope="colgroup" colspan="2">Bid</th>
                            <th scope="colgroup" colspan="2">Ask</th>
                            <th scope="col" rowspan="2">Bid<br />Average</th>
                            <th scope="col" rowspan="2">Ask<br />Average</th>
                            <th scope="col" rowspan="2">Buy –<br />Sell</th>
                            <th scope="col" rowspan="2">Total<br />Volume</th>
                            <th scope="col" rowspan="2">Total<br />Value</th>
                        </tr>
                        <tr>
                            <th scope="col">Orders</th>
                            <th scope="col">Volume</th>
                            <th scope="col">Orders</th>
                            <th scope="col">Volume</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="center">AAA</td>
                            <td>21.7</td>
                            <td>390</td>
                            <td class="dot_bd">625,800</td>
                            <td>390</td>
                            <td class="dot_bd">689,800</td>
                            <td>1,604.6</td>
                            <td>2,409.3</td>
                            <td>- 64,000</td>
                            <td>536,457</td>
                            <td>25,985,000</td>
                        </tr>
                        <tr>
                            <td class="center">CAB</td>
                            <td>21.7</td>
                            <td>390</td>
                            <td class="dot_bd">625,800</td>
                            <td>390</td>
                            <td class="dot_bd">689,800</td>
                            <td>1,604.6</td>
                            <td>2,409.3</td>
                            <td>- 64,000</td>
                            <td>536,457</td>
                            <td>25,985,000</td>
                        </tr>
                        <tr>
                            <td class="center">AAC</td>
                            <td>21.7</td>
                            <td>390</td>
                            <td class="dot_bd">625,800</td>
                            <td>390</td>
                            <td class="dot_bd">689,800</td>
                            <td>1,604.6</td>
                            <td>2,409.3</td>
                            <td>- 64,000</td>
                            <td>536,457</td>
                            <td>25,985,000</td>
                        </tr>
                        <tr>
                            <td class="center">BAA</td>
                            <td>21.7</td>
                            <td>390</td>
                            <td class="dot_bd">625,800</td>
                            <td>390</td>
                            <td class="dot_bd">689,800</td>
                            <td>1,604.6</td>
                            <td>2,409.3</td>
                            <td>- 64,000</td>
                            <td>536,457</td>
                            <td>25,985,000</td>
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