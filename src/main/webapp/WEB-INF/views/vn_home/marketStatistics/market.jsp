<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Thống kê thị trường | MIRAE ASSET</title>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Công cụ<br />đầu tư</h2>
            <ul>
                <li><a href="/home/marketStatistics/market.do" class="on">Thống kê thị trường</a></li>
                <li><a href="/home/marketStatistics/price.do">Lich sử giá</a></li>
                <li><a href="/home/marketStatistics/trading.do">Kết quả giao dịch</a></li>
                <li><a href="/home/marketStatistics/foreigner.do">Giao dịch NDT nước ngoài</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Thống kê thị trường</h3>

            <div class="market_chart">
                <div style="padding-top:300px; height:400px; background:#ccc; text-align:center; font-size:18px;">차트영역</div>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>