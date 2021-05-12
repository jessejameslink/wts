<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

<script>
	var page = 1;
	var fundType = 0;
	
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Sản phẩm & Dịch vụ";
	});
	
	function pdfReading(ids){		
		window.open("/pdfViewer.do?screen=fundinfo&ids=" + ids, "_blank");
	}
	
	function getFundData(type) {
		fundType = type;
		page = 1;
		getFundDataList(page);
	}
	function getFundDataList(page) {
		var param = {
				startDate			:	"1900/01/01",
				endDate				:	"2999/01/01",
				page				:	page,
				nType				:	fundType,
				lang  				: 	"<%= session.getAttribute("LanguageCookie") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/home/productsAndServices/getAllFundInfo.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				//console.log("FUND");
				//console.log(data);
				var fundInfoListStr = "";
				if(data.jsonObj.listSize != 0){
					fundInfoListStr += "";
					for(var i=0; i < data.jsonObj.list.length; i++){
						var datetime = data.jsonObj.list[i].created;
						var idx = datetime.indexOf(" ");
						var date = datetime.substring(0, idx);
						
						fundInfoListStr += "<tr>";
						fundInfoListStr += "	<td>" + date + "</td>"; // Date
						fundInfoListStr += "		<td class=\"headline\"><a href=\"/pdfViewer.do?screen=fundinfo&ids=" + data.jsonObj.list[i].id + "\" onclick=\"pdfReading('" + data.jsonObj.list[i].id + "');return false;\" style=\"cursor:pointer;\">" + data.jsonObj.list[i].title + "</a></td>";
						fundInfoListStr += "		<td><a href=\"/fundInfoFileDown.do?ids=" + data.jsonObj.list[i].id + "\" class=\"btn_down\" onclick=\"fundInfoFileDown('" + data.jsonObj.list[i].id + "');return false;\" style=\"cursor:pointer;\">report download</a></td>";
						fundInfoListStr += "</tr>";
					}
				} else {
					fundInfoListStr += "<tr><td class=\"no_result\" colspan=\"3\">Không tìm thấy dữ liệu</td></tr>";
			 	}
				// 리스트 세팅
				if(fundType == "0") {
					$("#fundDoc").html(fundInfoListStr);	
				} else if (fundType == "1") {
					$("#fundReport").html(fundInfoListStr);
				} else {
					$("#navReport").html(fundInfoListStr);
				}		 		

		 		drawPage(data.jsonObj.listSize, 20, (page ? page : 1)); // paging
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function fundInfoFileDown(id){
		location.href="/fundInfoDown.do?ids=" + id;
		
	}
	
	var util 		= 	new PageUtil();
	function drawPage(totCnt, pageSize, curPage) {
		util.totalCnt 	= 	totCnt; 		//	게시물의 총 건수
		util.pageRows 	= 	pageSize; 		// 	한번에 출력될 게시물 수
		util.disPagepCnt= 	5; 				//	화면 출력 페이지 수
		util.curPage 	= 	curPage;  		//	현재 선택 페이지
		util.setTotalPage();
		fn_DrowPageNumber();
	}

	function fn_DrowPageNumber() {
		$(".pagination").html(util.Drow());
	}

	function goPage(pageNo) {
		getFundDataList(pageNo);
	}

	function next() {
		page		=	util.getNext();
		util.curPage    =	page;
		goPage(page);
	}

	function prev() {
		page		=	util.getPrev();
		util.curPage    =	page;
		goPage(page);
	}
</script>

</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Sản phẩm<br />&amp; Dịch vụ</h2>
            <ul>
                <li><a href="/home/productsAndServices/individual.do">Môi giới Khách hàng cá nhân</a></li>
                <li><a href="/home/productsAndServices/institutional.do">Môi giới Khách hàng tổ chức</a></li>
                <li><a href="/home/productsAndServices/wealth.do">Quản lý tài sản</a></li>
                <li><a href="/home/productsAndServices/investment.do">Ngân hàng đầu tư</a></li>
                <li>
                	<a href="/home/productsAndServices/ofIntroduction.do" class="on">Quỹ</a>
                	<ul class="lnb_sub">
                        <li>
                        	<a href="/home/productsAndServices/ofIntroduction.do" class="on">Quỹ MAGEF</a>
                        	<ul class="lnb_sub1">
	                        	<li>
			                    	<a href="/home/productsAndServices/ofIntroduction.do" class="on">Thông tin quỹ</a>			                    				                   
			                    </li>
			                    <li>
			                    	<a href="/home/productsAndServices/ofInvesInstruction.do">Hướng dẫn đầu tư</a>
			                    			                    	
			                    </li>
			                    <li>
			                    	<a href="/home/productsAndServices/ofInfoDisclosures.do">Công bố thông tin</a>			                    	
			                    </li>                        
		                    </ul>
                        </li>
                        <li>
                        	<a href="/home/productsAndServices/ofbIntroduction.do">VFMVFB</a>                        	
                        </li>
                        <li>
                        	<a href="/home/productsAndServices/ofcIntroduction.do">VFMVFC</a>                        	
                        </li>
                        <li>
                        	<a href="/home/productsAndServices/of1Introduction.do">VFMVF1</a>                        	
                        </li>
                        <li>
                        	<a href="/home/productsAndServices/of4Introduction.do">VFMVF4</a>                        	
                        </li>                        
                    </ul>
                </li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
           <h3 class="cont_title">Quỹ đầu tư cổ phiếu tăng trưởng Mirae Asset Việt Nam (MAGEF)</h3>            
           <div>
               <h4 class="cont_subtitle" style="margin-top:10px; font-weight:600;">Thông tin quỹ MAGEF</h4> 
	           <table class="table_style_01">
	                <caption>Thông tin công ty</caption>
	                <colgroup>
	                    <col width="35%">
	                    <col />
	                </colgroup>
	                <tbody>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Tên Quỹ</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Quỹ đầu tư cổ phiếu tăng trưởng Mirae Asset Việt Nam (MAGEF)</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Công ty Quản Lý Quỹ</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Công Ty TNHH Quản Lý Quỹ Mirae Asset (Việt Nam)</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Loại hình Quỹ</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Quỹ mở</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Thị trường đầu tư</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Việt Nam</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Đơn vị tiền tệ</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>VNĐ</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Thời điểm thành lập</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Tháng 7/2019</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Ngân hàng lưu ký/giám sát</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Ngân hàng TNHH Một Thành Viên Standard Chartered (Việt Nam)</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Mục tiêu đầu tư</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Tăng trưởng giá trị tài sản ròng dài hạn thông qua tăng trưởng vốn gốc và thu nhập của các khoản đầu tư</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Chiến lược đầu tư</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Đầu tư chủ động tập trung vào cổ phiếu niêm yết, cổ phiếu đăng ký giao dịch có vốn hóa lớn, thanh khoản cao và cổ phiếu sẽ niêm yết, đăng ký giao dịch trên thị trường chứng khoán Việt Nam</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Tần suất giao dịch</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Hàng tuần / Thứ Tư (trừ ngày nghỉ lễ)</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Thời điểm đóng sổ lệnh</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>11:00 AM Thứ Ba (ngày T-1)</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Phí phát hành</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>0% giai đoạn IPO; 0,75% giá trị mua giai đoạn sau IPO</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Phí quản lý</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>1,75% Giá Trị Tài Sản Ròng (NAV) của Quỹ hàng năm</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Phí mua lại</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>0% nếu nắm giữ trên 1 năm; 1,25% giá trị bán nếu thời gian đầu tư không quá 1 năm</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Thời hạn thanh toán</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Trong vòng 05 ngày kể từ ngày Giao dịch</p>
	                        </td>
	                    </tr>
	                </tbody>
	            </table>
            </div>
            <div style="padding-top:15px;">
            	<h4 class="cont_subtitle" style="margin-top:10px; font-weight:600;">Kết quả hoạt động quỹ</h4>
            	<h4 class="cont_subtitle" style="margin-top:5px;">Mức sinh lời của quỹ</h4>
            	<div class="price_table" style="border:0px;">
                    <table>
                        <colgroup>
                            <col width="50%" />
                            <col width="50%" />
                        </colgroup>                        
                        <tbody>
                            <tr>
                                <td class="left" style="border-right:0px;border-left:0px;">Từ đầu năm 2019</br><b>---</b></td>
                                <td class="left" style="border-right:0px;border-left:0px;">----</br><b>---</b></td>
                            </tr>
                            <tr>
                                <td class="left" style="border-right:0px;border-left:0px;">----</br><b>---</b></td>
                                <td class="left" style="border-right:0px;border-left:0px;">----</br><b>---</b></td>
                            </tr>
                            <tr>
                                <td class="left" style="border-right:0px;border-left:0px;border-bottom:1px solid #ced5e4;">----</br><b>---</b></td>
                                <td class="left" style="border-right:0px;border-left:0px;"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            	<h4 class="cont_subtitle" style="margin-top:15px;">Giá trị NAV/CCQ (VNĐ)</h4>
            	<div class="price_table" style="border:0px;">
                    <table>
                        <colgroup>
                            <col width="50%" />
                            <col width="50%" />
                        </colgroup>                        
                        <tbody>
                            <tr>
                                <td class="left" style="border-right:0px;border-left:0px;">Tại ngày 20/08/2019</br><b>10,077.86 VNĐ</b></td>
                                <td class="left" style="border-right:0px;border-left:0px;">Cao nhất 52 tuần</br><b>10,077.86 VNĐ</b></td>
                            </tr>
                            <tr>
                                <td class="left" style="border-right:0px;border-left:0px;border-bottom:1px solid #ced5e4;">Thấp nhất 52 tuần</br><b>9,849.06 VNĐ</b></td>
                                <td class="left" style="border-right:0px;border-left:0px;"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="tab_container mg">
	            <div class="tab" style="padding-top:20px;">
	                <div>
	                    <a href="#document" class="on" onclick="getFundData(0);">Tài liệu Quỹ MAGEF</a>
	                    <a href="#report" onclick="getFundData(1);">Báo cáo Quỹ MAGEF</a>
	                    <a href="#nav" onclick="getFundData(2);">Báo cáo NAV</a>
	                </div>
	            </div>
	            <div class="tab_conts">
	            	<div id="document" class="on">
	            		<div class="board">                    
	                    <table>
		                    <caption>Tai lieu Quy MAGEF</caption>
		                    <colgroup>
		                        <col width="200" />
		                        <col width="*" />
		                        <col width="110" />
		                    </colgroup>
		                    <thead>
		                        <tr>
		                            <th scope="col">Ngày</th>
		                            <th scope="col">Tài liệu Quỹ MAGEF</th>
		                            <th scope="col">Tải về</th>
		                        </tr>
		                    </thead>
		                    <tbody id="fundDoc">
		                    </tbody>
		                </table>
		                </div>
	                </div>
	                <div id="report">
	                    <div class="board">                    
	                    <table>
		                    <caption>Bao cao Quy MAGEF</caption>
		                    <colgroup>
		                        <col width="200" />
		                        <col width="*" />
		                        <col width="110" />
		                    </colgroup>
		                    <thead>
		                        <tr>
		                            <th scope="col">Ngày</th>
		                            <th scope="col">Báo cáo Quỹ MAGEF</th>
		                            <th scope="col">Tải về</th>
		                        </tr>
		                    </thead>
		                    <tbody id="fundReport">
		                    </tbody>
		                </table>
		                </div>
	                </div>
	                <div id="nav">
	                    <div class="board">                    
	                    <table>
		                    <caption>Bao cao NAV</caption>
		                    <colgroup>
		                        <col width="200" />
		                        <col width="*" />
		                        <col width="110" />
		                    </colgroup>
		                    <thead>
		                        <tr>
		                            <th scope="col">Ngày</th>
		                            <th scope="col">Báo cáo NAV</th>
		                            <th scope="col">Tải về</th>
		                        </tr>
		                    </thead>
		                    <tbody id="navReport">
		                    </tbody>
		                </table>
		                </div>
	                </div>
	            </div>
            </div>           
        </div>
        <div class="pagination">
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>