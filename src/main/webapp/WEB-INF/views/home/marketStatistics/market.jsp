<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Market Overview | MIRAE ASSET</title>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Investment<br />Tools</h2>
            <ul>
                <li><a href="/home/marketStatistics/market.do" class="on">Market Overview</a></li>
                <li><a href="/home/marketStatistics/price.do">Price history</a></li>
                <li><a href="/home/marketStatistics/trading.do">Trading results</a></li>
                <li><a href="/home/marketStatistics/foreigner.do">Foreigner Transaction</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Market Overview</h3>

            <div class="market_chart">
                <div style="padding-top:300px; height:400px; background:#ccc; text-align:center; font-size:18px;">차트영역</div>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>