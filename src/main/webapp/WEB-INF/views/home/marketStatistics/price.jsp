<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Price history | MIRAE ASSET</title>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Investment<br />Tools</h2>
            <ul>
                <li><a href="/home/marketStatistics/market.do">Market Overview</a></li>
                <li><a href="/home/marketStatistics/price.do" class="on">Price history</a></li>
                <li><a href="/home/marketStatistics/trading.do">Trading results</a></li>
                <li><a href="/home/marketStatistics/foreigner.do">Foreigner Transaction</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Price history</h3>

            <div class="search">
                <form action="">
                    <fieldset class="search_wrap">
                        <legend>Search price history</legend>
                        <div class="keyword">
                            <label for="symbol">Symbol</label>
                            <input type="text" id="symbol" class="input" />
                        </div>

                        <div class="date">
                            <label for="search_date">Date</label>
                            <span class="date_box">
                                <input type="text" id="search_date" title="search start date" class="datepicker" />
                                <button type="button">Open Calendar</button>
                            </span>
                            <span class="tide">~</span>
                            <span class="date_box">
                                <input type="text" title="search end date" class="datepicker" />
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
                    <caption>price table</caption>
                    <colgroup>
                        <col width="90" />
                        <col width="*" />
                        <col width="70" />
                        <col width="70" />
                        <col width="70" />
                        <col width="70" />
                        <col width="70" />
                        <col width="70" />
                        <col width="90" />
                        <col width="90" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">Change<br />(+ -/%)</th>
                            <th scope="col">Open<br />Price</th>
                            <th scope="col">Highest<br />price</th>
                            <th scope="col">Lowest<br />price</th>
                            <th scope="col">Close<br />Price</th>
                            <th scope="col">Average<br />Price</th>
                            <th scope="col">Adjusted<br />Price</th>
                            <th scope="col">Trading<br />Volume</th>
                            <th scope="col">Put through<br />Volume</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="date">10/31/2016</td>
                            <td class="change">
                                <span class="up">+1.9 (+9.45)</span>
                            </td>
                            <td>21.8</td>
                            <td>23.2</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>536,457</td>
                            <td>15,000</td>
                        </tr>
                        <tr>
                            <td class="date">10/31/2016</td>
                            <td class="change">
                                <span class="low">-02 (-0.91%)</span>
                            </td>
                            <td>21.8</td>
                            <td>23.2</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>536,457</td>
                            <td>-</td>
                        </tr>
                        <tr>
                            <td class="date">10/31/2016</td>
                            <td class="change">
                                <span class="up">+1.9 (+9.45)</span>
                            </td>
                            <td>21.8</td>
                            <td>23.2</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>536,457</td>
                            <td>15,000</td>
                        </tr>
                        <tr>
                            <td class="date">10/31/2016</td>
                            <td class="change">
                                <span class="low">-02 (-0.91%)</span>
                            </td>
                            <td>21.8</td>
                            <td>23.2</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>536,457</td>
                            <td>-</td>
                        </tr>
                        <tr>
                            <td class="date">10/31/2016</td>
                            <td class="change">
                                <span class="up">+1.9 (+9.45)</span>
                            </td>
                            <td>21.8</td>
                            <td>23.2</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>536,457</td>
                            <td>15,000</td>
                        </tr>
                        <tr>
                            <td class="date">10/31/2016</td>
                            <td class="change">
                                <span class="low">-02 (-0.91%)</span>
                            </td>
                            <td>21.8</td>
                            <td>23.2</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>21.7</td>
                            <td>536,457</td>
                            <td>-</td>
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

</body>
</html>