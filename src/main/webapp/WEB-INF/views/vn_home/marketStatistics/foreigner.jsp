<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Giao dịch NDT nước ngoài | MIRAE ASSET</title>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Công cụ<br />đầu tư</h2>
            <ul>
                <li><a href="/home/marketStatistics/market.do">Thống kê thị trường</a></li>
                <li><a href="/home/marketStatistics/price.do">Lich sử giá</a></li>
                <li><a href="/home/marketStatistics/trading.do">Kết quả giao dịch</a></li>
                <li><a href="/home/marketStatistics/foreigner.do" class="on">Giao dịch NDT nước ngoài</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Giao dịch NDT nước ngoài</h3>

            <div class="search">
                <form action="">
                    <fieldset class="search_wrap">
                        <legend>Search Kết quả giao dịch</legend>

                        <div class="select">
                            <label for="market">Sàn</label>
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
                            <label for="search_date">Ngày</label>
                            <span class="date_box">
                                <input type="text" id="search_date" title="search start date" class="datepicker" />
                                <button type="button">Open Calendar</button>
                            </span>
                        </div>

                        <input type="submit" value="Tìm kiếm" class="btn_search" />
                    </fieldset>
                </form>
            </div>
            <!-- // .search -->

            <div class="price_table">
                <table>
                    <caption>Giao dịch NDT nước ngoài</caption>
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
                            <th scope="col" rowspan="2">MÃ CK</th>
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

</body>
</html>