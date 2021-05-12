<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Lich sử giá | MIRAE ASSET</title>
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
                <li><a href="/home/marketStatistics/price.do" class="on">Lich sử giá</a></li>
                <li><a href="/home/marketStatistics/trading.do">Kết quả giao dịch</a></li>
                <li><a href="/home/marketStatistics/foreigner.do">Giao dịch NDT nước ngoài</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Lich sử giá</h3>

            <div class="search">
                <form action="">
                    <fieldset class="search_wrap">
                        <legend>Search Lich sử giá</legend>
                        <div class="keyword">
                            <label for="symbol">Mã CK</label>
                            <input type="text" id="symbol" class="input" />
                        </div>

                        <div class="date">
                            <label for="search_date">Từ ngày</label>
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

                        <input type="submit" value="Tìm kiếm" class="btn_search" />
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
                            <th scope="col">Ngày</th>
                            <th scope="col">Thay đổi<br />(+ -/%)</th>
                            <th scope="col">Giá mở cửa</th>
                            <th scope="col">Giá cao nhất</th>
                            <th scope="col">Giá thấp nhất</th>
                            <th scope="col">Giá đóng cửa</th>
                            <th scope="col">Giá bình quân</th>
                            <th scope="col">Adjusted<br />Price</th>
                            <th scope="col">Tổng khối lượng</th>
                            <th scope="col">Giao dịch thỏa thuận (khối lượng)</th>
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