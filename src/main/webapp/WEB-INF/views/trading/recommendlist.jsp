<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String rec = (String) session.getAttribute("recom");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var rankfirst	=	true;
	$(document).ready(function(){
		$('#rankTbl').floatThead('destroy');
		
		var d 	= 	new Date();
		var fd	=	new Date();		
		fd.setMonth(d.getMonth() - 2);
				
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		$("#fromSearch").datepicker("setDate", fd.getDate() + "/" + (fd.getMonth() + 1) + "/" + fd.getFullYear());
				
		checkRecommend();
		
		$('.wrap_left button.wts_expand').on('click',function(){
			var existOn=$(this).parents('.left_content01').hasClass('on');
			var tabId = $("#tabOrdGrp4 ul li[class*=active]").attr("id");
			if(existOn){
				$(this).parents('.left_content01').removeClass('on');	
				$(this).text('+ EXPAND');
			}else{
				$(this).parents('.left_content01').addClass('on');
				$(this).text('- Reduce');
			}
			$('#recommendTbl').floatThead('reflow');
		});
		
		
		var $table	=	$('#recommendTbl');
		$('#recommendTbl').floatThead({
			position: 'relative',
			zIndex: function($table){
		        return 0;
		    },
			scrollContainer: true
		});
		
		$('#chkDisclaimer').click(function() {
	        if (!$(this).is(':checked')) {
	        	$('#btnDisclaimer').prop('disabled', true);	
	        } else {	        	
				$('#btnDisclaimer').prop('disabled', false);				
	        }
	    });
		
	});
	
	function checkRecommend() {
		if ("<%= rec %>" == "recom") {
			openDisclaimerPop();
		} else {
			searchRecommendList();
		}
	}

	function searchRecommendList() {
		$("#grdRecommend").find("tr").remove();
		getRecommendList();
	}

	function getRecommendList() {
		$("#tab8").block({message: "<span>LOADING...</span>"});
		
		var startDate 	= $("#fromSearch").val().split("/");
		var endDate 	= $("#toSearch").val().split("/");
		
		var param = {
			  fymd  : startDate[0] + "/" + startDate[1] + "/" +startDate[2]
			, tymd  : endDate[0] + "/" + endDate[1] + "/" +endDate[2]
			, symb  : $("#symbol").val()
			,  lang : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "en-US" : "vi-VN")
		};
		//console.log(param);
		$.ajax({
			url      : "/trading/data/getRecommendList.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				//console.log("Recommend data");
				//console.log(data);
				if(data.recommendList != null) {
					if(data.recommendList.list1 != null) {
						var htmlStr = "";
						for(var i=0; i < data.recommendList.list1.length; i++) {
							var recommendList = data.recommendList.list1[i];
							var className = "";
							(i%2 != 0) ? className = "even" : "";
							htmlStr += "<tr class='"+className+"'>"
							htmlStr += "	<td class=\"text_center c_code\">" + recommendList.reda + "</td>";
							var pe;
							if (recommendList.peri == "0") {
								if ("<%= langCd %>" == "en_US") {
									pe = "1 year";
								} else {
									pe = "1 năm";
								}
							} else {
								if ("<%= langCd %>" == "en_US") {
									pe = "6 months";
								} else {
									pe = "6 tháng";
								}
							}
							htmlStr += "	<td class=\"text_center c_code\">" + pe + "</td>";
							
							htmlStr += "	<td class=\"text_center c_code\"><a href=" + recommendList.vnli+ " target=\"_blank\" title=\"" + recommendList.vnli + "\">" + recommendList.symb + "</a></td>";
							
							htmlStr += "	<td class=\"text_center c_code\">" + recommendList.mark + "</td>";
							var re;
							if (recommendList.reco == "B") {
								if ("<%= langCd %>" == "en_US") {
									re = "BUY";
								} else {
									re = "MUA";
								}
								htmlStr += "	<td style=\"color:#17a668;font-weight:600;\" class=\"text_center c_code\">" + re + "</td>";
							} else if (recommendList.reco == "S") {
								if ("<%= langCd %>" == "en_US") {
									re = "SELL";
								} else {
									re = "BÁN";
								}
								htmlStr += "	<td style=\"color:#e807a1;font-weight:600;\" class=\"text_center c_code\">" + re + "</td>";
							} else if (recommendList.reco == "T") {
								if ("<%= langCd %>" == "en_US") {
									re = "TRADING BUY";
								} else {
									re = "TĂNG TỶ TRỌNG";
								}
								htmlStr += "	<td style=\"color:#17a668;font-weight:600;\" class=\"text_center c_code\">" + re + "</td>";
							} else {
								if ("<%= langCd %>" == "en_US") {
									re = "HOLD";
								} else {
									re = "NẮM GIỮ";
								}
								htmlStr += "	<td  style=\"color:#1278B3;font-weight:600;\" class=\"text_center c_code\">" + re + "</td>";
							}							
							
							htmlStr += "</tr>";
						}
						$("#grdRecommend").append(htmlStr);
					}
				}
				
				$('#recommendTbl').floatThead('reflow');								
				$("#tab8").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab8").unblock();
			}
		});
	}
	
	function agreeDisclaimer() {
		$.ajax({
			url      : "/trading/data/saveRecommend.do",
			dataType : "json",
			success  : function(data){
				$("#divDisclaimerPop").fadeOut();
				searchRecommendList();
			},
			error     :function(e) {
				console.log(e);
			}
		});		
	}
	
	function openDisclaimerPop(msg){
		$("#divDisclaimerPop").fadeIn();
	}
	
	function closeDisclaimerPop(){
		$("#divDisclaimerPop").fadeOut();
	}
</script>

<div class="tab_content" id="recommend_tab">
	<div role="tabpanel" class="tab_pane" id="tab8">
		<!-- Ranking -->
		<div style="float: right;padding-bottom: 5px;">
			<label for="symbol"><%= (langCd.equals("en_US") ? "Symbol" : "Mã CK") %></label>
			<input id="symbol" type="text" name="symbol" style="width:80px;">
			<label for="fromSearch"><%= (langCd.equals("en_US") ? "From" : "Từ") %></label>
			<input id="fromSearch" type="text" class="datepicker" id="fromDate" name="fromDate">
			<label for="toSearch"><%= (langCd.equals("en_US") ? "To" : "Đến") %></label>
			<input id="toSearch" type="text" class="datepicker" id="toDate" name="toDate">
			<button class="btn" type="button" onclick="checkRecommend()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			<button class="wts_expand" type="button">+ EXPAND</button>
		</div>
		<div class="grid_area" style="height:224px;">
			<div class="group_table">
				<table class="table" id="recommendTbl">
					<colgroup>
						<col />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
					</colgroup>
					<thead>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Recommend Date" : "Ngày khuyến nghị") %></th>
							<th><%= (langCd.equals("en_US") ? "Investment Term" : "Kỳ hạn") %></th>
							<th><%= (langCd.equals("en_US") ? "Stock ID" : "Mã CK") %></th>
							<th><%= (langCd.equals("en_US") ? "Exchange ID" : "Sàn") %></th>
							<th><%= (langCd.equals("en_US") ? "Recommended" : "Khuyến nghị") %></th>							
						</tr>
					</thead>
					<tbody id="grdRecommend">
					</tbody>
				</table>
			</div>
		</div>
		<!-- //Ranking -->
	</div>
	
	<!-- POPUP -->
	<div id="divDisclaimerPop" class="modal_wrap">
		<div class="modal_layer add total" style="padding: 20px 40px; border:1px solid;overflow:auto;height:300px; top:-260px;">
			<div class="total_wrap" style="width:100%;">
				<h2><%= (langCd.equals("en_US") ? "Disclaimer" : "Miễn trừ trách nhiệm") %></h2>
				<div class="search_area" style="text-align:left;">
					<div class="input_search">
						<label style="color:#333;display:inline;"><%= (langCd.equals("en_US") ? "This report is published by Mirae Asset (Vietnam) LLC (MAS), a broker-dealer registered in the Socialist Republic of Vietnam and a member of the Vietnam Stock Exchanges. Information and opinions contained herein have been compiled in good faith and from sources believed to be reliable, but such information has not been independently verified and MAS makes no guarantee, representation or warranty, express or implied, as to the fairness, accuracy, completeness or correctness of the information and opinions contained herein or of any translation into English from the Vietnamese language. In case of an English translation of a report prepared in the Vietnamese language, the original Vietnamese language report may have been made available to investors in advance of this report.</br>The intended recipients of this report are sophisticated institutional investors who have substantial knowledge of the local business environment, its common practices, laws and accounting principles and no person whose receipt or use of this report would violate any laws and regulations or subject MAS and its affiliates to registration or licensing requirements in any jurisdiction shall receive or make any use hereof.</br>This report is for general information purposes only and it is not and shall not be construed as an offer or a solicitation of an offer to effect transactions in any securities or other financial instruments. The report does not constitute investment advice to any person and such person shall not be treated as a client of MAS by virtue of receiving this report. This report does not take into account the particular investment objectives, financial situations, or needs of individual clients. The report is not to be relied upon in substitution for the exercise of independent judgment. Information and opinions contained herein are as of the date hereof and are subject to change without notice. The price and value of the investments referred to in this report and the income from them may depreciate or appreciate, and investors may   incur losses on investments. Past performance is not a guide to future performance. Future returns are not guaranteed, and a loss of original capital may occur. Mirae Asset Vietnam, its affiliates and their directors, officers, employees and agents do not accept any liability for any loss arising out of the use hereof.</br>MAS may have issued other reports that are inconsistent with, and reach different conclusions from, the opinions presented in this report. The reports may reflect different assumptions, views and analytical methods of the analysts who prepared them. MAS may make investment decisions that are inconsistent with the opinions and views expressed in this research report. MAS, its affiliates and their directors, officers, employees and agents may have long or short positions in any of the subject securities at any time and may make a purchase or sale, or offer to make a purchase or sale, of any such securities or other   financial instruments from time to time in the open market or otherwise, in each case either as principals or agents. MAS and its affiliates may have had, or may be expecting to enter into, business relationships with the subject companies to provide investment banking, market-making or other financial services as are permitted under applicable laws and regulations.</br>No part of this document may be copied or reproduced in any manner or form or redistributed or published, in whole or in part, without the prior written consent of MAS." : "Báo cáo này được phát hành bởi Công ty TNHH Chứng Khoán Mirae Asset (Việt Nam) (MAS), là một công ty chứng khoán môi giới đăng ký tại nước Cộng hòa xã hội chủ nghĩa Việt Nam và là thành viên của các Sở giao dịch chứng khoán Việt Nam. Thông tin và ý kiến trong báo cáo này đã được tổng hợp một cách trung thực và từ các nguồn được cho là đáng tin cậy, tuy nhiên những thông tin này chưa được xác minh một cách độc lập và MAS không bảo đảm, đại diện hay cam kết, trực tiếp hay ngụ ý, về tính công bằng, chính xác, đầy đủ của thông tin và ý kiến trong tài liệu này hoặc bất kỳ bản dịch tiếng Anh nào từ ngôn ngữ tiếng việt. Trong trường hợp bản dịch tiếng Anh của một báo cáo được soạn bằng tiếng Việt, báo cáo gốc bằng tiếng việt có thể được cung cấp cho các nhà đầu tư trước báo cáo này.</br>Đối tượng chủ yếu của báo cáo này là các nhà đầu tư tổ chức chuyên nghiệp, là những tổ chức có nền tảng kiến thức vững chắc về môi trường kinh doanh địa phương, các thông lệ, luật pháp và các nguyên tắc kế toán, không người nào nhận hoặc sử dụng báo cáo này sẽ vi phạm pháp luật và quy định hoặc buộc MAS và các công ty liên kết của MAS phải đáp ứng các yêu cầu về đăng ký hoặc cấp phép tại bất kỳ lãnh thổ tài phán nào sẽ nhận hoặc sử dụng báo cáo.</br>Báo cáo này chỉ dành cho mục đích tham khảo và nó không và sẽ không được hiểu là một đề nghị hoặc một lời tư vấn chào hàng để thực hiện bất kỳ giao dịch nào trong lĩnh vực chứng khoán hoặc các lĩnh vực tài chính khác. Báo cáo này không phải là một bản tư vấn đầu tư cho bất kỳ đối tượng nào và người nhận báo cáo này cũng không nhất thiết được xem là khách hàng của MAS. Báo cáo này hoàn toàn không được xem là các mục tiêu đầu tư cụ thể, tình hình tài chính hoặc nhu cầu của khách hàng cá nhân. Báo cáo sẽ không được xem xét để thay thế cho việc thực hiện phán quyết độc lập. Thông tin và ý kiến trong báo cáo này được thực hiện vào ngày ghi trên báo cáo và có thể thay đổi mà không cần thông báo trước. Giá và giá trị của các khoản đầu tư được đề cập trong báo cáo này và thu nhập từ chúng có thể mất giá hoặc được đánh giá cao hơn, và các nhà đầu tư có thể phải chịu tổn thất cho các khoản đầu tư. Các thành tích trong quá khứ không được xem là một chỉ dẫn để đạt được các kết quả trong tương lai. Các khoản lợi nhuận trong tương lai sẽ không được đảm bảo, và nhà đầu từ hoàn toàn có thể bị thua lỗ số vốn ban đầu. MAS, các công ty liên kết, ban giám đốc, nhân viên và đại diện của công ty không phải chịu bất kỳ trách nhiệm pháp lý nào đối với bất kỳ tổn thất nào phát sinh từ việc sử dụng báo cáo này.</br>MAS hoàn toàn có thể phát hành các báo cáo khác có nội dung không tương thích hoặc có các kết luận khác so với ý kiến được trình bày trong báo cáo này. Các báo cáo có thể phản ánh các giả định, quan điểm và phương pháp phân tích khác nhau theo sự nghiên cứu của từng nhà phân tích. MAS có quyền đưa ra quyết định đầu tư không giống với ý kiến và quan điểm thể hiện trong báo cáo nghiên cứu này. MAS, các công ty liên kết và ban giám đốc, nhân viên và đại diện của công ty có thể thực hiện mua hay bán vị thế đối với bất kỳ loại chứng khoán nào ở bất kỳ thời điểm nào và có thể thực hiện mua hoặc bán, hoặc đề nghị mua hoặc bán, bất kỳ loại chứng khoán hoặc các công cụ tài chính khác tùy từng thời điểm thị trường mở cửa hoặc trong các trường hợp khác. MAS và các công ty liên kết có thể đã hoặc sẽ tham gia vào các mối quan hệ kinh doanh với các công ty mục tiêu để cung cấp dịch vụ ngân hàng đầu tư, tạo lập thị trường hoặc các dịch vụ tài chính khác theo các quy định của pháp luật hiện hành.</br>Không nội dung nào trong báo cáo này đươc sao chép hoặc được điều chỉnh lại dưới bất kỳ hình thức nào hoặc được phân phối lại hoặc xuất bản, toàn bộ hoặc một phần, mà không có sự đồng ý trước bằng văn bản của MAS.") %></label>
					</div>
				</div>
				<div style="padding-top:10px;">
					<input type="checkbox" id="chkDisclaimer" style="padding-left:25px;"><%= (langCd.equals("en_US") ? "I read and agreed." : "Tôi đã đọc và đồng ý.") %></input>
				</div>
				<div style="padding-top:10px;">
					<button type="button" id="btnDisclaimer" onclick="agreeDisclaimer()" disabled><%= (langCd.equals("en_US") ? "Agreed" : "Đồng ý") %></button>
				</div>
			</div>
			<button class="close" style="width:15px;height:15px;" type="button" onclick="closeDisclaimerPop()"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>
		</div>
	</div>
</div>
</html>
