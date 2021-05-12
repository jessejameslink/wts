<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Hỗ trợ";
		getMarginList();

	});

	function pdfReading(ids){		
		window.open("/pdfViewer.do?screen=margin&ids=" + ids, "_blank");
	}
	
	function getMarginList(page){		
		var param = {
				page				:	page
		};

		$.ajax({
			dataType  : "json",
			url       : "/marginListRead.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				var marginListStr = "";
				if(data.jsonObj != null && data.jsonObj.listSize != 0){
					marginListStr += "";
					for(var i=0; i < data.jsonObj.list.length; i++){
						var datetime = data.jsonObj.list[i].created;
						var idx = datetime.indexOf(" ");
						var date = datetime.substring(0, idx);
						marginListStr += "	<tr>";
						marginListStr += "		<td>" + date + "</td>";
						marginListStr += "		<td class=\"headline\"><a href=\"/pdfViewer.do?screen=margin&ids=" + data.jsonObj.list[i].id + "\" onclick=\"pdfReading('" + data.jsonObj.list[i].id + "');return false;\" style=\"cursor:pointer;\">" + data.jsonObj.list[i].title + "</a></td>";
						marginListStr += "		<td><a href=\"/marginListDown.do?ids=" + data.jsonObj.list[i].id + "\" class=\"btn_down\" onclick=\"marginFileDown('" + data.jsonObj.list[i].id + "');return false;\" style=\"cursor:pointer;\">report download</a></td>";
						marginListStr += "	</tr>";
					}
				}else{
					marginListStr += "<tr><td class=\"no_result\" colspan=\"3\">Không tìm thấy dữ liệu</td></tr>";
			 	}
				// 리스트 세팅
		 		$("#marginList").html(marginListStr);

		 		drawPage(data.jsonObj.listSize, 4, (page ? page : 1)); // paging
			},
			error     :function(e) {
				console.log(e);
			}

		});
	}
	
	function marginFileDown(id){
		location.href="/marginListDown.do?ids=" + id;
		
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
		getMarginList(pageNo);
	}

	function next() {
		var page		=	util.getNext();
		util.curPage    =	page;
		goPage(page);
	}

	function prev() {
		var page		=	util.getPrev();
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
            <h2>Hỗ trợ</h2>
            <ul>
                <li><a href="/home/support/account.do">Mở tài khoản tiền tại ngân hàng ACB</a></li>
                <li><a href="/home/support/wooriAccount.do">Mở tài khoản tiền tại ngân hàng Woori</a></li>
                <li><a href="/home/support/depositCash.do">Nộp tiền</a></li>
                <li><a href="/home/support/depositStock.do">Lưu ký chứng khoán</a></li>
                <li><a href="/home/support/cashAdvance.do">Ứng trước tiền bán chứng khoán</a></li>
                <li><a href="/home/support/cashTransfer.do">Chuyển tiền</a></li>
                <li>
                    <a href="/home/support/marginGuideline.do" class="on">Giao dịch ký quỹ</a>
                    <ul class="lnb_sub">
                        <li><a href="/home/support/marginGuideline.do">Hướng dẫn</a></li>
                        <li><a href="/home/support/marginList.do" class="on">Danh mục và thông tin cơ bản</a></li>
                    </ul>
                </li>
                <li><a href="/home/support/sms.do">SMS</a></li>
                <li><a href="/home/support/securities.do">Qui định giao dịch chứng khoán</a></li>
                <li><a href="/home/support/web.do">Hướng dẫn giao dịch trực tuyến qua website</a></li>
                <li><a href="/home/support/mobile.do">Hướng dẫn giao dịch qua ứng dụng điện thoại</a></li>
                <li><a href="/home/support/fee.do">Biểu phí</a></li>
                <li><a href="/home/subpage/openAccount.do">Hướng dẫn hồ sơ mở tài khoản chứng khoán cơ sở</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Danh mục và thông tin cơ bản</h3>

            <div class="mg_info">
                <h4>1. Thời hạn khoản vay</h4>
                <table>
                    <caption>margin loan term</caption>
                    <colgroup>
                        <col width="260" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Thời hạn tối đa cho 1 khoản vay</th>
                            <td>03 tháng</td>
                        </tr>
                        <tr>
                            <th scope="row">Gia hạn khoản vay</th>
                            <td>Tối đa thêm 1 kỳ 3 tháng</td>
                        </tr>
                    </tbody>
                </table>

                <h4>2. Lãi suất cho vay Giao dịch Ký quỹ</h4>
                <div class="box">
                    <ul class="info_list">
                        <li>
                            <span class="title">Lãi suất thông thường</span>
                            <span class="desc">
                                <span>12% / năm</span>
                            </span>
                        </li>
                        <li>
                            <span class="title">Lãi suất quá hạn</span>
                            <span class="desc">
                                <span>150% lãi suất cho vay thông thường</span>
                            </span>
                        </li>
                    </ul>
                </div>

                <h4>3. Phương thức gọi bổ sung tài sản đảm bảo</h4>
                <p>Gửi tin nhắn SMS hoặc gọi điện thoại theo thông tin Quý Khách hàng đã đăng ký trong Hợp đồng Giao dịch Ký quỹ.</p>

                <h4>4. Danh mục chứng khoán giao dịch ký quỹ</h4>                
            </div>
            <div class="board">
                <table>
                    <caption>List margin</caption>
                    <colgroup>
                        <col width="200" />
                        <col width="*" />
                        <col width="110" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Ngày</th>
                            <th scope="col">Danh mục chứng khoán ký quỹ</th>
                            <th scope="col">Tải về</th>
                        </tr>
                    </thead>
                    <tbody id="marginList">
                    </tbody>
                </table>
            </div>

            <div class="pagination">
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>