<%@page import="com.mystudy.project.dao.DAO"%>
<%@page import="com.mystudy.project.vo.CartListVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

  <script> 

	$(function(){	

	  	$(".selectAll").change(function(){
	  		
	  		if($(".selectAll").is(":checked")){
  				let sum = parseInt($("#totalProductPrice").val());
	  			$(".seleteEach").each(function(){
	  				$(this).prop("checked", true);	
					sum += parseInt($(this).parent().parent().find("td:eq(7)").text());
	  			});
	  			
  	  			$("#totalProductPrice").val(sum);
	  			if (sum >= 70000) {
	  				$("#shippingfee").val("0"); 
	  				$("#totalPrice").val(sum);
	  			} else {
	  				$("#shippingfee").val("3000");  
	  				$("#totalPrice").val(sum+3000);
	  			}
	  		} else {
	  			$(".seleteEach").each(function(){
	  				$(this).prop("checked", false);	
	  
	  			});	  
	  			$("#totalProductPrice").val("0");
	  			$("#shippingfee").val("3000"); 
	  			$("#totalPrice").val("0");
	  		}
	  		
	  	});
	  	
	  	$("#totalProductPrice").change(function(){
	  		let sum = parseInt($("#totalProductPrice").val());
	  		if (sum >= 70000) {
	  			$("#totalPrice").val(sum);
	  			$("#shippingfee").val("0");  
	  		} else {
	  			$("#shippingfee").val("3000");
	  			let shippingfee = parseInt($("#shippingfee").val());
	  			$("#totalPrice").val(sum+3000);
	  		}
	  		
	  	});
	  	
		$(document).on('click','.seleteEach', function(){
			
			if ($("input[class=seleteEach]:checked").length==$(".seleteEach").length){
				$(".selectAll").prop('checked',true);
			} else {
				$(".selectAll").prop('checked',false);				
			}
		});	  	
	  	
  		$(".seleteEach").change(function(){
			console.log("eachPrice: " + $(this).parent().parent().find("td:eq(7)").text());
			let sum = parseInt($("#totalProductPrice").val());
  			
			if($(this).is(":checked")){
	  			sum += parseInt($(this).parent().parent().find("td:eq(7)").text());
  			} else {
  			    sum -= parseInt($(this).parent().parent().find("td:eq(7)").text());
	  		}
  			
  			$("#totalProductPrice").val(sum);

  			
  			if (parseInt($("#totalProductPrice").val()) < 70000) {
  				$("#shippingfee").val("3000");
  			} else {
  				$("#shippingfee").val("0");  
  			}
  			
  			$("#totalPrice").val(parseInt($("#totalProductPrice").val())+parseInt($("#shippingfee").val()));
  			
  		});
  		
	});  // document ready??? ???	
	
	$(document).on("change", ".qty", function () {
	  		//??????????????? ???????????? ?????? update??????
	  		//${cart.price * cart.qty }?????? ?????? ?????? ??????
	  		//alert("?????? ?????? ???!" + $(this).val()+", cartNo: " + $(this).parent().parent().find("td:eq(1)").attr("value"));		
	  		let eachTotalPrice = $(this).parent().next();
	  		
	  		let selectEach = $(this).parent().parent().find("td:eq(0)").find("input:eq(0)");

	  		//alert("eachPrice: " + $(this).parent().next().text());
	  		
			$.ajax("ajaxController", {
				type : "get",
				data : "type=updateQty&cartNo="+$(this).parent().parent().find("td:eq(1)").attr("value")+"&qty="+$(this).val(),
				dataType : "json",
				success : function(data){
					
					//???????????? function??? ???????????? data??? ?????? date??? ?????? ???
					//alert("Ajax ?????? ?????? - ???????????? ????????? : " + data);
					let qty = data.qty;
					let cartPrice = data.cartPrice;
					
					let htmlTag = "";
					htmlTag += data.qty*data.cartPrice;
					//alert("????????? html: " +  htmlTag);
					
					//alert("ajax ??? eachPrice text: " + $(this).parent().next().text());
					
					//console.log(this);
					//console.log($(this).parent().next());
					
					eachTotalPrice.text(htmlTag);
					$(".seleteEach").prop("checked", false);
					$("#totalProductPrice").val("0");
					$("#shippingfee").val("3000");
					$("#totalPrice").val("0");
		
				},
				error : function(jqXHR, textStatus, errorThrown){
					alert("Ajax ?????? ?????? : \n"
							+ "jqXHR : " + jqXHR.readyState + "\n"
							+ "textStatus : " + textStatus + "\n"
							+ "errorThrown : " + errorThrown);
				}
				
	  		})
	});
	
  	
  	function deleteCart(cartNo) {
		
  		$.ajax("ajaxController", {

			type : "get",
			data : "type=deleteCart&cartNo="+cartNo,
			dataType : "json",
			success : function(data){
				
				//???????????? function??? ???????????? data??? ?????? date??? ?????? ???
				alert("Ajax ?????? ?????? - ???????????? ????????? : " + data);
				let clist = data.list;
				
				let htmlTag = "";
				
				$.each(clist, function(index, item){
				
					
					htmlTag += '<tr>'; 
					htmlTag += '<td class="align-middle"><input type="checkbox" name="selectProduct" class="seleteEach"></td>'; 
					htmlTag += '<td class="cartNo align-middle" value="'+this.cartNo+'">'+this.cartNo+'</td>'; 
					htmlTag += '<td class="align-middle"><img src="./img/'+this.thumnail+'" alt="img" width="100%"></td>'; 
					htmlTag += '<td class="align-middle"><a href="controllersk?type=productdetail&productno='+this.productNo+'">'+this.productName+'</a></td>'; 
					htmlTag += '<td class="align-middle"><input type="text" name="optionSize" class="optionSize" value="'+this.optionSize+'" style="width: 100%" readonly></td>'; 
					htmlTag += '<td class="align-middle"><input type="number" name="price" class="price" value="'+this.price+'" style="width: 100%" readonly></td>'; 
					htmlTag += '<td class="align-middle"><input type="number" name="qty" class="qty" value="'+this.amount+'" style="width: 100%" min="1"></td>'; 
					htmlTag += '<td class="eachTotalPrice align-middle">'+(this.price*this.amount)+'</td>'; 
					htmlTag += '<td class="align-middle">'; 
					htmlTag += '<input type="hidden" name="cartNo" value="'+this.cartNo+'">'; 
					htmlTag += '<input type="hidden" name="productNo" value="'+this.productNo+'">'; 
					htmlTag += '<input type="button" class="btn btn btn-sm" onclick="deleteCart('+this.cartNo+')" value="????????????">'; 
					htmlTag += '<input type="button" class="btn btn btn-sm" onclick="addLike('+this.productNo+')" value="??????????????????">'; 
					htmlTag += '</td>'; 
					htmlTag += '</tr>'; 
					
				})
				
				$("#cartListBody").html(htmlTag);
				// document.location.reload();
				// history.go(0);
			},
			error : function(jqXHR, textStatus, errorThrown){
				alert("Ajax ?????? ?????? : \n"
						+ "jqXHR : " + jqXHR.readyState + "\n"
						+ "textStatus : " + textStatus + "\n"
						+ "errorThrown : " + errorThrown);
			}
			
  	  	}) // ajax??? ???	 
  	  	
	} // delectCart??? ???
	
	function delete_cart_select(frm) {
		
  		$(".seleteEach").each(function(){
			//unchecked??? ?????? cartNo??? ??? ?????????
			if ($(this).prop('checked') == false) {
				$(this).parent().siblings("td:eq(7)").find("input:eq(0)").attr("disabled", true);
			} 
  		});
  		/*
		$.ajax("ajaxController", {

			type : "get",
			data : "type=deleteCartSelect&cartNo="+frm.cartNo.value,
			dataType : "json",
			success : function(data){
				
				//???????????? function??? ???????????? data??? ?????? date??? ?????? ???
				let clist = data.list;
				
				let htmlTag = "";
				
				$.each(clist, function(index, item){
				
					htmlTag += '<tr>'; 
					htmlTag += '<td class="align-middle"><input type="checkbox" name="selectProduct" class="seleteEach"></td>'; 
					htmlTag += '<td class="cartNo align-middle" value="'+this.cartNo+'">'+this.cartNo+'</td>'; 
					htmlTag += '<td class="align-middle"><img src="./img/'+this.thumnail+'" alt="img" width="100%"></td>'; 
					htmlTag += '<td class="align-middle"><a href="controllersk?type=productdetail&productno='+this.productNo+'">'+this.productName+'</a></td>'; 
					htmlTag += '<td class="align-middle"><input type="text" name="optionSize" class="optionSize" value="'+this.optionSize+'" style="width: 100%" readonly></td>'; 
					htmlTag += '<td class="align-middle"><input type="number" name="price" class="price" value="'+this.price+'" style="width: 100%" readonly></td>'; 
					htmlTag += '<td class="align-middle"><input type="number" name="qty" class="qty" value="'+this.amount+'" style="width: 100%" min="1"></td>'; 
					htmlTag += '<td class="eachTotalPrice align-middle">'+(this.price*this.amount)+'</td>'; 
					htmlTag += '<td class="align-middle">'; 
					htmlTag += '<input type="hidden" name="cartNo" value="'+this.cartNo+'">'; 
					htmlTag += '<input type="hidden" name="productNo" value="'+this.productNo+'">'; 
					htmlTag += '<input type="button" name="btn btn btn-sm" onclick="deleteCart('+this.cartNo+')" value="????????????">'; 
					htmlTag += '<input type="button" name="btn btn btn-sm" onclick="addLike('+this.productNo+')" value="??????????????????">'; 
					htmlTag += '</td>'; 
					htmlTag += '</tr>'; 
				})
				
				$("#cartListBody").html(htmlTag);
				
			},
			error : function(jqXHR, textStatus, errorThrown){
				alert("Ajax ?????? ?????? : \n"
						+ "jqXHR : " + jqXHR.readyState + "\n"
						+ "textStatus : " + textStatus + "\n"
						+ "errorThrown : " + errorThrown);
			}
			
  	  	}) // ajax??? ???	
  		*/
  		
  		$("#typeId").attr("value", "deleteCartSelect");
  		frm.action = "${pageContext.request.contextPath }/controllersk";
  		frm.submit();
  		
	}
	
	
	function delete_cart_all(){
		
  		$.ajax("ajaxController", {

			type : "get",
			data : "type=deleteCartAll",
			dataType : "json",
			success : function(data){
				
				//???????????? function??? ???????????? data??? ?????? date??? ?????? ???
				alert("Ajax ?????? ?????? - ???????????? ????????? : " + data);
				let result = data.result;
				
				alert(result + "?????? ????????? ?????????????????????");
				
				let htmlTag = "";
				
				htmlTag += '<tr><td colspan="9">??????????????? ?????? ????????????</td></tr>'; 
				
				$("#cartListBody").html(htmlTag);
			},
			error : function(jqXHR, textStatus, errorThrown){
				alert("Ajax ?????? ?????? : \n"
						+ "jqXHR : " + jqXHR.readyState + "\n"
						+ "textStatus : " + textStatus + "\n"
						+ "errorThrown : " + errorThrown);
			}
			
  	  	}) // ajax??? ???	
		
	}
	
	
	function addLike (productNo) {

  		$.ajax("ajaxController", {

			type : "get",
			data : "type=addLike&productNo="+productNo,
			dataType : "json",
			success : function(data){
				
				//???????????? function??? ???????????? data??? ?????? date??? ?????? ???
				alert("Ajax ?????? ?????? - ???????????? ????????? : " + data);
				let result = data.result;
				
				if (result == 1) {
					alert("??????????????? ?????????????????????");
				} else {
					alert("?????? ??????????????? ???????????? ????????????");
				}
			},
			error : function(jqXHR, textStatus, errorThrown){
				alert("Ajax ?????? ?????? : \n"
						+ "jqXHR : " + jqXHR.readyState + "\n"
						+ "textStatus : " + textStatus + "\n"
						+ "errorThrown : " + errorThrown);
			}
			
  	  	}) // ajax??? ???	
		
	}
	
	
  	function go_order(frm) {
  		
		let cnt = 0;
  		$(".seleteEach").each(function(){
			//unchecked??? ?????? cartNo??? ??? ?????????
			if ($(this).prop('checked') == false) {
				$(this).parent().siblings("td:eq(7)").find("input:eq(0)").attr("disabled", true);
			} else {
				cnt++;
			}
  		});
  		
  		if (cnt == 0) {
  			alert("?????? ????????? ????????? ????????? ?????????");
  			return false;
  		}
  		
  		frm.action = "${pageContext.request.contextPath }/controllersk";
		frm.submit();

	}
  	
	
  </script>
</head>

<body>
<div class="container">

	<jsp:include page="/common/header.jsp"></jsp:include>
	<div>
		<form>
		<table id="cartList" class="table text-center" width="100%">
		<colgroup>
			<col style="width: 5%;">
			<col style="width: 5%;">
			<col style="width: 10%;">
			<col style="width: 25%;">
			<col style="width: 12%;">
			<col style="width: 8%;">
			<col style="width: 5%;">
			<col style="width: 10%;">
			<col style="width: 10%;">
		</colgroup>
		<thead class="bg-light">
			<tr>
				<th><input type="checkbox" class="selectAll" name="selectProducts"></th>
				<th>??????</th>
				<th>?????????</th>
				<th>?????????</th>
				<th>??????</th>
				<th>?????????</th>
				<th>??????</th>
				<th>????????????</th>
				<th>????????????</th>
			</tr>
		</thead>
		<tbody id="cartListBody">
			<c:if test="${empty list }">
				<tr><td colspan="9">??????????????? ?????? ????????????</td></tr>
			</c:if>
			<c:forEach var="cart" items="${list }" >
				<tr>
					<td class="align-middle"><input type="checkbox" class="seleteEach" name="selectProduct"></td>
					<td class="cartNo align-middle" value="${cart.cartNo }">${cart.cartNo }</td>
					<td class="align-middle"><img src="./img/${cart.thumnail }" alt="img" width="100%"></td>
					<td class="align-middle"><a href="controllersk?type=productdetail&productNo=${cart.productNo }"> ${cart.productName }</a></td>
					<td class="align-middle"><input type="text" name="optionSize" class="text-center optionSize border-0 bg-transparent" value="${cart.optionSize }" style="width: 100%" readonly></td>
					<td class="align-middle"><input type="number" name="price" class="text-center price border-0 bg-transparent" value="${cart.price }" style="width: 100%" readonly></td>
					<td class="align-middle"><input type="number" name="qty" class="text-center qty border-0 bg-transparent" value="${cart.amount }" style="width: 100%" min="1"></td>
					<td class="eachTotalPrice align-middle">${cart.price * cart.amount }</td>
					<td class="align-middle">
						<input type="hidden" name="cartNo" value="${cart.cartNo }">
						<input type="hidden" name="productNo" value="${cart.productNo }">
						<input type="button" class="btn btn-sm" onclick="deleteCart(${cart.cartNo })" value="????????????">
						<input type="button" class="btn btn-sm" onclick="addLike(${cart.productNo})" value="??????????????????">
					</td>
				</tr>
			</c:forEach>
		</tbody>
		<tfoot class="bg-light">
			<tr>
				<td colspan="2">
					<span class="float-left">????????????</span>
				</td>
				<td class="float-none"></td>
				<td colspan="8" class="text-right">
					<span>
					<span>???????????????: <strong><input type="text" id="totalProductPrice" name="totalPrice" class="text-center border-0 bg-transparent" size="4" value="0" readonly></strong></span>
					<span>?????????: <input type="text" id="shippingfee" class="text-center border-0 bg-transparent" name="shippingfee" value="3000" size="3" readonly></span>
					<span>???????????????: <strong><input type="text" id="totalPrice" name="totalPrice" class="text-center border-0 bg-transparent" size="4" value="0" readonly></strong></span>
					</span>
				</td>
			</tr>
			<tr>
				<td colspan="9" class="text-left">
					<input type="button" class="btn btn-outline-light text-dark border btn-sm" onclick="delete_cart_select(this.form)" value="??????????????????">
					<input type="button" class="btn btn-outline-light text-dark border btn-sm " onclick="delete_cart_all()" value="?????????????????????">
				</td>
			</tr>
		</tfoot>
		</table>
			<div class="text-center">
			<input type="hidden" id="typeId" name="type" value="pay">
			<input type="button" class=" btn btn-dark btn-lg" onclick="go_order(this.form)" value="??? ??? ??? ???">
			</div>
		</form>
	</div>
</div> <!-- container end -->

	<footer>
		<%@ include file="/common/footer.jspf" %>
	</footer>

</body>
</html>