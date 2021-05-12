<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>My Asset | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/US/css/miraeasset.css">
<script type="text/javascript" src="/resources/US/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/js/mireaasset.js"></script>
</head>
<body>

<%@include file="header.jsp"%>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <div id="contents" class="full_width">
            <h3 class="cont_title">My Asset</h3>

            <div class="my_asset">
                <div class="search">
                    <div class="select">
                        <label for="acc">Account</label>
                        <div class="select_wrap acc">
                            <select id="acc">
                                <option value="">077-C-123456</option>
                                <option value="">077-C-123456</option>
                                <option value="">077-C-123456</option>
                            </select>
                        </div>
                    </div>

                	<div class="select">
                        <label for="bank">Bank</label>
                        <div class="select_wrap">
                            <select id="bank">
                                <option value="">ACB</option>
                                <option value="">HOSE</option>
                                <option value="">HNXSE</option>
                                <option value="">UPCOM</option>
                                <option value="">VSD</option>
                            </select>
                        </div>
                    </div>
                </div>

                <ul class="summary">
                    <li class="sm01">
                        <div>Total Asset</div>
                        <span>228,736,563</span>
                    </li>
                    <li class="sm02">
                        <div>Total Evaluation<br />Amount</div>
                        <span>228,736,563</span>
                    </li>
                    <li class="sm03">
                        <div>Total Profit/Loss</div>
                        <span>228,736,563</span>
                    </li>
                    <li class="sm04">
                        <div>%Profit/Loss</div>
                        <span>228,736,563</span>
                    </li>
                </ul>

                <h4 class="sec_title">Portfolio / Stock balance</h4>
                <div class="price_table">
                    <table>
                        <caption>Cash balance</caption>
                        <colgroup>
                            <col width="40" />
                            <col width="*" />
                            <col span="9" width="102" />
                        </colgroup>
                        <thead class="multi_row">
                            <tr>
                                <th rowspan="2" scope="col">No</th>
                                <th rowspan="2" scope="col">Stock</th>
                                <th scope="col">Total</th>
                                <th scope="col">Hold in day</th>
                                <th scope="col">T1 Buy</th>
                                <th scope="col">Mortgage</th>
                                <th scope="col">A. Trading</th>
                                <th scope="col">A. withdrawal</th>
                                <th scope="col">Ave. Price</th>
                                <th scope="col">Buy Value</th>
                                <th scope="col">Gain / Loss</th>
                            </tr>
                            <tr>
                                <th scope="col">Usable</th>
                                <th scope="col">T0 Buy</th>
                                <th scope="col">T2 Buy</th>
                                <th scope="col">Holding</th>
                                <th scope="col">A. deposit</th>
                                <th scope="col">Pending Ent.</th>
                                <th scope="col">Cur. Price</th>
                                <th scope="col">Market Value</th>
                                <th scope="col">% G / L</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="center">No</td>
                                <td class="center">Stock</td>
                                <td>
                                    <div>Total</div>
                                    <div>Usable</div>
                                </td>
                                <td>
                                    <div>Hold in day</div>
                                    <div>T0 Buy</div>
                                </td>
                                <td>
                                    <div>T1 Buy</div>
                                    <div>T2 Buy</div>
                                </td>
                                <td>
                                    <div>Mortgage</div>
                                    <div>Holding</div>
                                </td>
                                <td>
                                    <div>A. Trading</div>
                                    <div>A. deposit</div>
                                </td>
                                <td>
                                    <div>A. withdrawal</div>
                                    <div>Pending Ent.</div>
                                </td>
                                <td>
                                    <div>Ave. Price</div>
                                    <div>Cur. Price</div>
                                </td>
                                <td>
                                    <div>Buy Value</div>
                                    <div>Market Value</div>
                                </td>
                                <td>
                                    <div>Gain / Loss</div>
                                    <div>% G / L</div>
                                </td>
                            </tr>
                            <tr>
                                <td class="center">No</td>
                                <td class="center">Stock</td>
                                <td>
                                    <div>Total</div>
                                    <div>Usable</div>
                                </td>
                                <td>
                                    <div>Hold in day</div>
                                    <div>T0 Buy</div>
                                </td>
                                <td>
                                    <div>T1 Buy</div>
                                    <div>T2 Buy</div>
                                </td>
                                <td>
                                    <div>Mortgage</div>
                                    <div>Holding</div>
                                </td>
                                <td>
                                    <div>A. Trading</div>
                                    <div>A. deposit</div>
                                </td>
                                <td>
                                    <div>A. withdrawal</div>
                                    <div>Pending Ent.</div>
                                </td>
                                <td>
                                    <div>Ave. Price</div>
                                    <div>Cur. Price</div>
                                </td>
                                <td>
                                    <div>Buy Value</div>
                                    <div>Market Value</div>
                                </td>
                                <td>
                                    <div>Gain / Loss</div>
                                    <div>% G / L</div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>