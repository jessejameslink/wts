<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Mobile trading guideline | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/HOME/css/miraeasset.css">
<script type="text/javascript" src="/resources/US/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/js/mireaasset.js"></script>
<script type="text/javascript" src="/resources/US/js/trading_mobile.js"></script>

</head>
<body>
<script>
	function downloadFile() {
		$("body").block({message: "<span>LOADING...</span>"});
		location.href="/downloadFile.do?ids=4&lang=en";
		$("body").unblock();
	}
	
	
	
	function calcHeight()
	{
		//find the height of the internal page
		//var the_height = document.getElementById('iframeView').contentWindow.document.body.scrollHeight;
	  	//change the height of the iframe
		//document.getElementById('iframeView').height = the_height;
	}
	
	
    
</script>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Mobile<br /> Trading</h2>                
            <ul>
                <li onclick="slideshow.pos(0)"><a href="#">Login</a></li>
                <li onclick="slideshow.pos(1)"><a href="#">All Menu</a></li>
                <!--<li onclick="slideshow.pos(2)"><a href="#">Current Price</a></li> -->
                <li onclick="slideshow.pos(2)"><a href="#">Stock Order</a></li>
                <li onclick="slideshow.pos(3)"><a href="#">Stock Order from </br>Watch List</a></li>
                <li onclick="slideshow.pos(4)"><a href="#">Stock Order from </br>Price Board</a></li>
                <li onclick="slideshow.pos(5)"><a href="#">Chart</a></li>
                <li onclick="slideshow.pos(6)"><a href="#">Stock Statistic</a></li>
                <li onclick="slideshow.pos(7)"><a href="#">Cash/Loan Service</a></li>
                <li onclick="slideshow.pos(8)"><a href="#">Portfolio Management</a></li>
                <li onclick="slideshow.pos(9)"><a href="#">Market News</a></li>
            </ul>  
        </div>
        <!-- // lnb -->

        <div id="contents">
        <!-- 
            <iframe id="tese" name="test" src="http://data.masvn.com/en/news"/>
         -->
         <iframe id='iframeView' src="http://data.masvn.com/en/news" onLoad="calcHeight();" frameboarder='0' marginwidth='0' marginheight='0' width='100%' height='1024px' scrolling='no'></iframe>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->


<script type="text/javascript">
	
</script>


</body>
</html>