<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String loginId = (String) session.getAttribute("ClientV");
	String loginName = (String) session.getAttribute("mvSName");
%>
<html>
<script>
	$(document).ready(function() {
		var note = "";
		var id = "<%= loginId %>";
		var name = "<%= loginName %>";
		if ("<%= langCd %>" == "en_US") {
			note = "For Securities: Deposit for contract No. " + id + " of Mr/Mrs: " + name + "</br>";
			note += "For Derivaties: Deposit for contract No. " + id + "_D of Mr/Mrs: " + name + "";
		} else {
			note = "Cơ sở: Nộp tiền vào tài khoản số " + id + " của Ông/Bà: " + name + "</br>";
			note += "Phái sinh: Nộp tiền vào tài khoản số " + id + "_D của Ông/Bà: " + name + "";
		}
		$("#noteText").html(note);
	});
	
	$("#cdo_wms1").on('change', function(e) {
		$("#cdo_wms2").prop("checked", false);
		$("#cdo_wms2_1").prop("checked", false);
		$("#cdo_wms2_2").prop("checked", false);
		$("#cdo_wms2_3").prop("checked", false);
		$("#cdo_wms2_4").prop("checked", false);
		$("#cdo_wms2_5").prop("checked", false);
		$("#cdo_wms2_6").prop("checked", false);
		$("#cdo_wms2_1").prop("disabled", true);
		$("#cdo_wms2_2").prop("disabled", true);
		$("#cdo_wms2_3").prop("disabled", true);
		$("#cdo_wms2_4").prop("disabled", true);
		$("#cdo_wms2_5").prop("disabled", true);
		$("#cdo_wms2_6").prop("disabled", true);
		
		$("#cdo_wms1_1").prop("disabled", false);
		$("#cdo_wms1_2").prop("disabled", false);
		$("#cdo_wms1_3").prop("disabled", false);
		$("#cdo_wms1_4").prop("disabled", false);
		$("#cdo_wms1_5").prop("disabled", false);
		$("#cdo_wms1_6").prop("disabled", false);
		$("#cdo_wms1_7").prop("disabled", false);
		$("#cdo_wms1_8").prop("disabled", false);
		$("#cdo_wms1_9").prop("disabled", false);
		$("#cdo_wms1_10").prop("disabled", false);
		$("#cdo_wms1_11").prop("disabled", false);
		$("#cdo_wms1_12").prop("disabled", false);
	});
	$("#cdo_wms2").on('change', function(e) {
		$("#cdo_wms1").prop("checked", false);
		$("#cdo_wms1_1").prop("checked", false);
		$("#cdo_wms1_2").prop("checked", false);
		$("#cdo_wms1_3").prop("checked", false);
		$("#cdo_wms1_4").prop("checked", false);
		$("#cdo_wms1_5").prop("checked", false);
		$("#cdo_wms1_6").prop("checked", false);
		$("#cdo_wms1_7").prop("checked", false);
		$("#cdo_wms1_8").prop("checked", false);
		$("#cdo_wms1_9").prop("checked", false);
		$("#cdo_wms1_10").prop("checked", false);
		$("#cdo_wms1_11").prop("checked", false);
		$("#cdo_wms1_12").prop("checked", false);
		
		$("#cdo_wms1_1").prop("disabled", true);
		$("#cdo_wms1_2").prop("disabled", true);
		$("#cdo_wms1_3").prop("disabled", true);
		$("#cdo_wms1_4").prop("disabled", true);
		$("#cdo_wms1_5").prop("disabled", true);
		$("#cdo_wms1_6").prop("disabled", true);
		$("#cdo_wms1_7").prop("disabled", true);
		$("#cdo_wms1_8").prop("disabled", true);
		$("#cdo_wms1_9").prop("disabled", true);
		$("#cdo_wms1_10").prop("disabled", true);
		$("#cdo_wms1_11").prop("disabled", true);
		$("#cdo_wms1_12").prop("disabled", true);
		
		$("#cdo_wms2_1").prop("disabled", false);
		$("#cdo_wms2_2").prop("disabled", false);
		$("#cdo_wms2_3").prop("disabled", false);
		$("#cdo_wms2_4").prop("disabled", false);
		$("#cdo_wms2_5").prop("disabled", false);
		$("#cdo_wms2_6").prop("disabled", false);		
	});
	
	$("#cdo_wms1_1").on('change', function(e) {		
		$("#cdo_wms1_2").prop("checked", false);
		$("#cdo_wms1_3").prop("checked", false);
		$("#cdo_wms1_4").prop("checked", false);
		$("#cdo_wms1_5").prop("checked", false);
		$("#cdo_wms1_6").prop("checked", false);
		$("#cdo_wms1_7").prop("checked", false);
		$("#cdo_wms1_8").prop("checked", false);
		$("#cdo_wms1_9").prop("checked", false);
		$("#cdo_wms1_10").prop("checked", false);
		$("#cdo_wms1_11").prop("checked", false);
		$("#cdo_wms1_12").prop("checked", false);
	});
	
	$("#cdo_wms1_2").on('change', function(e) {
		$("#cdo_wms1_1").prop("checked", false);
		$("#cdo_wms1_3").prop("checked", false);
		$("#cdo_wms1_4").prop("checked", false);
		$("#cdo_wms1_5").prop("checked", false);
		$("#cdo_wms1_6").prop("checked", false);
		$("#cdo_wms1_7").prop("checked", false);
		$("#cdo_wms1_8").prop("checked", false);
		$("#cdo_wms1_9").prop("checked", false);
		$("#cdo_wms1_10").prop("checked", false);
		$("#cdo_wms1_11").prop("checked", false);
		$("#cdo_wms1_12").prop("checked", false);
	});
	$("#cdo_wms1_3").on('change', function(e) {
		$("#cdo_wms1_1").prop("checked", false);
		$("#cdo_wms1_2").prop("checked", false);
		$("#cdo_wms1_4").prop("checked", false);
		$("#cdo_wms1_5").prop("checked", false);
		$("#cdo_wms1_6").prop("checked", false);
		$("#cdo_wms1_7").prop("checked", false);
		$("#cdo_wms1_8").prop("checked", false);
		$("#cdo_wms1_9").prop("checked", false);
		$("#cdo_wms1_10").prop("checked", false);
		$("#cdo_wms1_11").prop("checked", false);
	});
	$("#cdo_wms1_4").on('change', function(e) {
		$("#cdo_wms1_1").prop("checked", false);
		$("#cdo_wms1_2").prop("checked", false);
		$("#cdo_wms1_3").prop("checked", false);
		$("#cdo_wms1_5").prop("checked", false);
		$("#cdo_wms1_6").prop("checked", false);
		$("#cdo_wms1_7").prop("checked", false);
		$("#cdo_wms1_8").prop("checked", false);
		$("#cdo_wms1_9").prop("checked", false);
		$("#cdo_wms1_10").prop("checked", false);
		$("#cdo_wms1_11").prop("checked", false);
		$("#cdo_wms1_12").prop("checked", false);
	});
	$("#cdo_wms1_5").on('change', function(e) {
		$("#cdo_wms1_1").prop("checked", false);
		$("#cdo_wms1_2").prop("checked", false);
		$("#cdo_wms1_3").prop("checked", false);
		$("#cdo_wms1_4").prop("checked", false);
		$("#cdo_wms1_6").prop("checked", false);
		$("#cdo_wms1_7").prop("checked", false);
		$("#cdo_wms1_8").prop("checked", false);
		$("#cdo_wms1_9").prop("checked", false);
		$("#cdo_wms1_10").prop("checked", false);
		$("#cdo_wms1_11").prop("checked", false);
		$("#cdo_wms1_12").prop("checked", false);
	});
	$("#cdo_wms1_6").on('change', function(e) {
		$("#cdo_wms1_1").prop("checked", false);
		$("#cdo_wms1_2").prop("checked", false);
		$("#cdo_wms1_3").prop("checked", false);
		$("#cdo_wms1_4").prop("checked", false);
		$("#cdo_wms1_5").prop("checked", false);
		$("#cdo_wms1_7").prop("checked", false);
		$("#cdo_wms1_8").prop("checked", false);
		$("#cdo_wms1_9").prop("checked", false);
		$("#cdo_wms1_10").prop("checked", false);
		$("#cdo_wms1_11").prop("checked", false);
		$("#cdo_wms1_12").prop("checked", false);
	});
	$("#cdo_wms1_7").on('change', function(e) {
		$("#cdo_wms1_1").prop("checked", false);
		$("#cdo_wms1_2").prop("checked", false);
		$("#cdo_wms1_3").prop("checked", false);
		$("#cdo_wms1_4").prop("checked", false);
		$("#cdo_wms1_5").prop("checked", false);
		$("#cdo_wms1_6").prop("checked", false);
		$("#cdo_wms1_8").prop("checked", false);
		$("#cdo_wms1_9").prop("checked", false);
		$("#cdo_wms1_10").prop("checked", false);
		$("#cdo_wms1_11").prop("checked", false);
		$("#cdo_wms1_12").prop("checked", false);
	});
	$("#cdo_wms1_8").on('change', function(e) {
		$("#cdo_wms1_1").prop("checked", false);
		$("#cdo_wms1_2").prop("checked", false);
		$("#cdo_wms1_3").prop("checked", false);
		$("#cdo_wms1_4").prop("checked", false);
		$("#cdo_wms1_5").prop("checked", false);
		$("#cdo_wms1_6").prop("checked", false);
		$("#cdo_wms1_7").prop("checked", false);
		$("#cdo_wms1_9").prop("checked", false);
		$("#cdo_wms1_10").prop("checked", false);
		$("#cdo_wms1_11").prop("checked", false);
		$("#cdo_wms1_12").prop("checked", false);
	});
	$("#cdo_wms1_9").on('change', function(e) {
		$("#cdo_wms1_1").prop("checked", false);
		$("#cdo_wms1_2").prop("checked", false);
		$("#cdo_wms1_3").prop("checked", false);
		$("#cdo_wms1_4").prop("checked", false);
		$("#cdo_wms1_5").prop("checked", false);
		$("#cdo_wms1_6").prop("checked", false);
		$("#cdo_wms1_7").prop("checked", false);
		$("#cdo_wms1_8").prop("checked", false);
		$("#cdo_wms1_10").prop("checked", false);
		$("#cdo_wms1_11").prop("checked", false);
		$("#cdo_wms1_12").prop("checked", false);
	});
	$("#cdo_wms1_10").on('change', function(e) {
		$("#cdo_wms1_1").prop("checked", false);
		$("#cdo_wms1_2").prop("checked", false);
		$("#cdo_wms1_3").prop("checked", false);
		$("#cdo_wms1_4").prop("checked", false);
		$("#cdo_wms1_5").prop("checked", false);
		$("#cdo_wms1_6").prop("checked", false);
		$("#cdo_wms1_7").prop("checked", false);
		$("#cdo_wms1_8").prop("checked", false);
		$("#cdo_wms1_9").prop("checked", false);
		$("#cdo_wms1_11").prop("checked", false);
		$("#cdo_wms1_12").prop("checked", false);
	});
	$("#cdo_wms1_11").on('change', function(e) {
		$("#cdo_wms1_1").prop("checked", false);
		$("#cdo_wms1_2").prop("checked", false);
		$("#cdo_wms1_3").prop("checked", false);
		$("#cdo_wms1_4").prop("checked", false);
		$("#cdo_wms1_5").prop("checked", false);
		$("#cdo_wms1_6").prop("checked", false);
		$("#cdo_wms1_7").prop("checked", false);
		$("#cdo_wms1_8").prop("checked", false);
		$("#cdo_wms1_9").prop("checked", false);
		$("#cdo_wms1_10").prop("checked", false);
		$("#cdo_wms1_12").prop("checked", false);
	});
	$("#cdo_wms1_12").on('change', function(e) {
		$("#cdo_wms1_1").prop("checked", false);
		$("#cdo_wms1_2").prop("checked", false);
		$("#cdo_wms1_3").prop("checked", false);
		$("#cdo_wms1_4").prop("checked", false);
		$("#cdo_wms1_5").prop("checked", false);
		$("#cdo_wms1_6").prop("checked", false);
		$("#cdo_wms1_7").prop("checked", false);
		$("#cdo_wms1_8").prop("checked", false);
		$("#cdo_wms1_9").prop("checked", false);
		$("#cdo_wms1_10").prop("checked", false);
		$("#cdo_wms1_11").prop("checked", false);
	});

	$("#cdo_wms2_1").on('change', function(e) {
		$("#cdo_wms2_2").prop("checked", false);
		$("#cdo_wms2_3").prop("checked", false);
		$("#cdo_wms2_4").prop("checked", false);
		$("#cdo_wms2_5").prop("checked", false);
		$("#cdo_wms2_6").prop("checked", false);
	});
	$("#cdo_wms2_2").on('change', function(e) {
		$("#cdo_wms2_1").prop("checked", false);
		$("#cdo_wms2_3").prop("checked", false);
		$("#cdo_wms2_4").prop("checked", false);
		$("#cdo_wms2_5").prop("checked", false);
		$("#cdo_wms2_6").prop("checked", false);
	});
	$("#cdo_wms2_3").on('change', function(e) {
		$("#cdo_wms2_1").prop("checked", false);
		$("#cdo_wms2_2").prop("checked", false);
		$("#cdo_wms2_4").prop("checked", false);
		$("#cdo_wms2_5").prop("checked", false);
		$("#cdo_wms2_6").prop("checked", false);
	});
	$("#cdo_wms2_4").on('change', function(e) {
		$("#cdo_wms2_1").prop("checked", false);
		$("#cdo_wms2_2").prop("checked", false);
		$("#cdo_wms2_3").prop("checked", false);
		$("#cdo_wms2_5").prop("checked", false);
		$("#cdo_wms2_6").prop("checked", false);
	});
	$("#cdo_wms2_5").on('change', function(e) {
		$("#cdo_wms2_1").prop("checked", false);
		$("#cdo_wms2_2").prop("checked", false);
		$("#cdo_wms2_3").prop("checked", false);
		$("#cdo_wms2_4").prop("checked", false);
		$("#cdo_wms2_6").prop("checked", false);
	});
	$("#cdo_wms2_6").on('change', function(e) {
		$("#cdo_wms2_1").prop("checked", false);
		$("#cdo_wms2_2").prop("checked", false);
		$("#cdo_wms2_3").prop("checked", false);
		$("#cdo_wms2_4").prop("checked", false);
		$("#cdo_wms2_5").prop("checked", false);
	});
</script>
<div class="tab_content banking">
	<div role="tabpanel" class="tab_pane" id="tab2">
		<div class="cdo_header">
			<p class="remitter">
				<span><%= (langCd.equals("en_US") ? "Remitter" : "Người chuyển") %> : <%= loginName %></span>
				<span><%= (langCd.equals("en_US") ? "Account No" : "Số tài khoản") %> : <%= loginId %></span>
			</p>
			<p><%= (langCd.equals("en_US") ? "Beneficiary : Please choose" : "Người thụ hưởng: Vui lòng chọn") %></p>
		</div>

		<div class="cdo_container">
			<div class="pull_left">
				<p>
					<input type="radio" id="cdo_wms1" />
					<label for="cdo_wms1"><%= (langCd.equals("en_US") ? "Mirae Asset Securities (Vietnam) Limited Liability Company" : "Công ty TNHH Chứng khoán Mirae Asset (Vietnam)") %></label>
				</p>
				<div class="grid_area" style="height:400px;">
					<div class="group_table">
						<table class="table">
							<caption class="hidden">Mirae Asset Securities (Vietnam) Limited Liability Company</caption>
							<colgroup>
								<col width="50" />
								<col />
								<col />
							</colgroup>
							<thead>
								<tr>
									<th scope="col"><%= (langCd.equals("en_US") ? "No" : "STT") %></th>
									<th scope="col"><%= (langCd.equals("en_US") ? "Account" : "Tài khoản") %></th>
									<th scope="col"><%= (langCd.equals("en_US") ? "At Bank" : "Ngân hàng") %></th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td colspan="3" class="text_left"><%= (langCd.equals("en_US") ? "Beneficiary Company : Mirae Asset Securities (Vietnam) Limited Liability Company" : "Bên thụ hưởng: Công ty TNHH Chứng khoán Mirae Asset (Vietnam)") %></td>
								</tr>
<tr><td class="text_center">1</td><td class="text_left"><input type="radio" id="cdo_wms1_1"/><label for="cdo_wms1_1">130.10000.428432</label></td><td class="text_left">BIDV-SGD-II</td></tr>
<tr><td class="text_center">2</td><td class="text_left"><input type="radio" id="cdo_wms1_2"/><label for="cdo_wms1_1">119.10000.667667</label></td><td class="text_left">BIDV - CN NKKN</td></tr>
<tr><td class="text_center">3</td><td class="text_left"><input type="radio" id="cdo_wms1_3"/><label for="cdo_wms1_1">100912046537</label></td><td class="text_left">Woori Bank Viet Nam – HCM Branch</td></tr>
<tr><td class="text_center">4</td><td class="text_left"><input type="radio" id="cdo_wms1_4"/><label for="cdo_wms1_1">700-000-315906</label></td><td class="text_left">Shinhan Viet Nam Bank – HCM</td></tr>
<tr><td class="text_center">5</td><td class="text_left"><input type="radio" id="cdo_wms1_5"/><label for="cdo_wms1_1">0071-0009-45-205</label></td><td class="text_left">VCB – PGD số 3 – HCM</td></tr>
<tr><td class="text_center">6</td><td class="text_left"><input type="radio" id="cdo_wms1_6"/><label for="cdo_wms1_1">031-704-070000-359</label></td><td class="text_left">HDBank – PGD Duy Tân – HCM</td></tr>
<tr><td class="text_center">7</td><td class="text_left"><input type="radio" id="cdo_wms1_7"/><label for="cdo_wms1_1">673.999.89</label></td><td class="text_left">ACB – CN Sài gòn – HCM</td></tr>
<tr><td class="text_center">8</td><td class="text_left"><input type="radio" id="cdo_wms1_8"/><label for="cdo_wms1_1">2001-150560-00020</label></td><td class="text_left">Eximbank – PGD Bến Thành – HCM</td></tr>
<tr><td class="text_center">9</td><td class="text_left"><input type="radio" id="cdo_wms1_9"/><label for="cdo_wms1_1">6263812-001</label></td><td class="text_left">Indovina Bank – Chợ lớn Branch</td></tr>
<tr><td class="text_center">10</td><td class="text_left"><input type="radio" id="cdo_wms1_10"/><label for="cdo_wms1_1">9999.9714.9999</label></td><td class="text_left">Buu Dien Lien Viet Bank – PGD Sài Gòn –  HCM</td></tr>
<tr><td class="text_center">11</td><td class="text_left"><input type="radio" id="cdo_wms1_11"/><label for="cdo_wms1_1">810.00110.0000.875</label></td><td class="text_left">Kookmin Bank – CN HCM</td></tr>
<tr><td class="text_center">12</td><td class="text_left"><input type="radio" id="cdo_wms1_12"/><label for="cdo_wms1_1">126.000.035.468</label></td><td class="text_left">Vietin Bank - CN HCM</td></tr>

							</tbody>
						</table>
					</div>
				</div>
			</div>

			<div class="pull_right">
				<p>
					<input type="radio" id="cdo_wms2" />
					<label for="cdo_wms2" class="text_left"><%= (langCd.equals("en_US") ? "Mirae Asset Securities (Vietnam) Limited Liability Company - Ha Noi Branch" : "Công ty TNHH Chứng khoán Mirae Asset (VN) - Chi nhánh Hà Nội") %></label>
				</p>
				<div class="grid_area" style="height:400px;">
					<div class="group_table">
						<table class="table">
							<caption class="hidden">Mirae Asset (Vietnam) Limited Liability Company - Ha Noi Branch</caption>
							<colgroup>
								<col width="50" />
								<col />
								<col />
							</colgroup>
							<thead>
								<tr>
									<th scope="col"><%= (langCd.equals("en_US") ? "No" : "STT") %></th>
									<th scope="col"><%= (langCd.equals("en_US") ? "Account" : "Tài khoản") %></th>
									<th scope="col"><%= (langCd.equals("en_US") ? "At Bank" : "Ngân hàng") %></th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<%--
									<td colspan="3"><%= (langCd.equals("en_US") ? "Beneficiary Company : Mirae Asset Wealth Management Securities (Vietnam) Limited Liability" : "Bên thụ hưởng: Công ty TNHH Chứng khoán Mirae Asset Wealth Management (Vietnam)") %></td>
									--%>
									<td colspan="3" class="text_left"><%= (langCd.equals("en_US") ? "Beneficiary Company : Mirae Asset Securities (Vietnam) Limited Liability Company - Ha Noi Branch" : "Bên thụ hưởng: Công ty TNHH Chứng khoán Mirae Asset (Vietnam) - Chi nhánh Hà Nội") %></td>
								</tr>
								 <tr><td class="text_center">1</td><td class="text_left"><input type="radio" id="cdo_wms2_1"/><label for="cdo_wms1_1">160.10.00.000841.7</label></td><td class="text_left">BIDV – SGD III</td></tr>
								 <tr><td class="text_center">2</td><td class="text_left"><input type="radio" id="cdo_wms2_2"/><label for="cdo_wms1_1">100920065668</label></td><td class="text_left">Woori Bank – Hà nội Branch</td></tr>
								 <tr><td class="text_center">3</td><td class="text_left"><input type="radio" id="cdo_wms2_3"/><label for="cdo_wms1_1">020040425226</label></td><td class="text_left">Sacombank – Hàng Bài Branch</td></tr>
								 <tr><td class="text_center">4</td><td class="text_left"><input type="radio" id="cdo_wms2_4"/><label for="cdo_wms1_1">0011004019439</label></td><td class="text_left">VCB – SGD  – HN</td></tr>
								 <tr><td class="text_center">5</td><td class="text_left"><input type="radio" id="cdo_wms2_5"/><label for="cdo_wms1_1">0571103960007</label></td><td class="text_left">MB Bank – Hoàn Kiếm Branch</td></tr>
								 <tr><td class="text_center">6</td><td class="text_left"><input type="radio" id="cdo_wms2_6"/><label for="cdo_wms1_1">19131444557018</label></td><td class="text_left">Techcombank - Wholesale bank</td></tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!-- // .cdo_container -->

		<div class="line_block">
			<span><%= (langCd.equals("en_US") ? "Remark :" : "Ghi chú :") %></span><br /><span id="noteText"></span>
		</div>

		<div class="mdi_bottom center">
			<input class="color" type="submit" value=<%= (langCd.equals("en_US") ? "Next" : "Tiếp theo") %>>
			<input type="reset" value=<%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %>>
		</div>
	</div>
</div>
</html>
