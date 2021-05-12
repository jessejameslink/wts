var wtsAjax = function(){
	var self = this;
	
	this.setValue = {
		dataType:"JSON",
		url:"",
		data:"",		
		async:true,
		error:self.errorCall(),
		success:self.successCall(data),
		beforeSend:self.beforSend(),
		complete:self.complete()
	};
};

wtsAjax.prototype={
		
	send : function(set){
		
		self.setValue.url = set.url;
		self.setValue.data = set.data;
		self.setValue.success = set.success;
		
		if(set.loading == "Y"){
			self.loadingShow();
		}else{
			self.loadingHide();
		}
		
		$.ajax(self.setValue);
	},
	
	successCall:function(data){
		
	},
	
	beforSend:function(){
		
	}
	
	/*this.complete=function(){
		
	};
	
	this.loadingShow=function(){
		
	};
	
	this.loadingHide=function(){
		
	};
		*/
};

