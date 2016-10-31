//判断访问终端
var browser={
    versions:function(){
        var u = navigator.userAgent, app = navigator.appVersion;
        return {
            trident: u.indexOf('Trident') > -1, //IE内核
            presto: u.indexOf('Presto') > -1, //opera内核
            webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
            gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1,//火狐内核
            mobile: !!u.match(/AppleWebKit.*Mobile.*/), //是否为移动终端
            ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
            android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器
            iPhone: u.indexOf('iPhone') > -1 , //是否为iPhone或者QQHD浏览器
            iPad: u.indexOf('iPad') > -1, //是否iPad
            webApp: u.indexOf('Safari') == -1, //是否web应该程序，没有头部与底部
            weixin: u.indexOf('MicroMessenger') > -1, //是否微信 （2015-01-22新增）
            qq: u.match(/\sQQ/i) == " qq" //是否QQ
        };
    }(),
    language:(navigator.browserLanguage || navigator.language).toLowerCase()
}

//判断是否IE内核
//if(browser.versions.trident){ alert("is IE"); }
//判断是否webKit内核
//if(browser.versions.webKit){ alert("is webKit"); }
//判断是否移动端
//if(browser.versions.mobile||browser.versions.android||browser.versions.ios){ alert("移动端"); }

//  说明：
//  mobile_  前缀代表移动端调用标识
//  hyl_     前缀代表前端的js函数


//登录模块
function hyl_login(username,password,ischecked){
    if(browser.versions.android){
       window.jna.mobile_login(username,password,ischecked);
    }else{
       mobile_login(username,password,ischecked);
    }
}
function hyl_setUsernamePassToView(username,password){
    $(".username").val(username);
    $(".password").val(password);
}

function  hyl_loadDefaultUsernamePass(){
 if(browser.versions.android){
       window.jna.mobile_loadDefaultUsernamePass();
    }else{
       mobile_loadDefaultUsernamePass();
    }
}



//设备列表模块
function hyl_requestDevicesCmd(){
      if(browser.versions.android){
      }else{
       mobile_requestDevices();
      }

}
//发送设备命令
function hyl_setFieldCmd(fieldValue,fieldId,objectId){
      if(browser.versions.android){
         window.jna.mobile_setFieldCmd(fieldValue,fieldId,objectId);
      }else{
         mobile_setFieldCmd(fieldValue,fieldId,objectId);
      }

}

function hyl_updateDeviceName(name,objectId){
      if(browser.versions.android){
         window.jna.mobile_updateDeviceName(name,objectId);
      }else{
         mobile_updateDeviceName(name,objectId);
      }

}

function hyl_toWifiSetting(){
       if(browser.versions.android){
           window.jna.mobile_toWifiSetting();
        }else{
           mobile_toWifiSetting();
        }
}
function hyl_configInfoToWIFIDevice(ssid,password){
         if(browser.versions.android){
                   window.jna.mobile_configInfoToWIFIDevice(ssid,password);
         }else{
                    mobile_configInfoToWIFIDevice(ssid,password);
         }
}
//跳转到设备详细界面
function hyl_toDetailPage(objectId,clientSn){

    if(browser.versions.android){
       window.jna.mobile_toDetailPage(objectId,clientSn);
    }else{
       mobile_toDetailPage(objectId,clientSn);
    }


}

function getClassIcon(classId,appJSON){
	var defaultIcon="img/defaultDevIcon.png";

	if(classId==232){
	   return "img/device_camera0.png";
	}

	if(appJSON.localClassLayoutTracker==true){
		var classLayoutArr=appJSON.localClassLayout;
		
		for(var i=0;i<classLayoutArr.length;i++){
			if(classLayoutArr[i].localClassId==classId){
				defaultIcon="img/"+classLayoutArr[i].localIcon;
				break;
			}
		}
		
	}
	return defaultIcon;
}


function hyl_loadDevicesData(devices,appJSON){

//var devices=eval("("+devices+")");
//var classTable=eval("("+classTable+")");
    $("#deviceTable").empty();
	/*
      device :
     
     [
     
     {"bindVmId":0,"fieldMap":{"72":"35","71":"1","74":"bedroom"},"accessYN":0,"connType":0,"objectId":120,"clientSn":"BFF0006101418","locId":0,"name":"红外移动传感器","gatewayId":0,"classId":7,"netState":0,"ccsClientId":193}
     ]
     
      class  :
     
---------->{"classId1":[fields],"classId2":[fields]}
     
     
	{"3":[{"fieldName":"battery","deviceCmdYN":0,"displayName":"剩余电量","aggrMethod":0,"dataType":1,"presistYN":1,"tsYN":0,"deviceStateYN":1,"fieldId":23},{"fieldName":"location","deviceCmdYN":0,"displayName":"安装位置","aggrMethod":0,"dataType":1,"presistYN":1,"tsYN":0,"deviceStateYN":0,"fieldId":24},{"fieldName":"alert","deviceCmdYN":0,"displayName":"警报","aggrMethod":0,"dataType":1,"presistYN":0,"tsYN":0,"deviceStateYN":1,"fieldId":21},{"fieldName":"status","deviceCmdYN":0,"displayName":"开关状态","aggrMethod":0,"dataType":1,"presistYN":0,"tsYN":0,"deviceStateYN":1,"fieldId":22},{"fieldName":"test","deviceCmdYN":0,"displayName":"test","aggrMethod":0,"dataType":1,"presistYN":1,"tsYN":1,"deviceStateYN":0,"fieldId":260}]
     ,
     
    }
	
	
	*/
    
	if(devices!=undefined&&devices.length>0){
		for(var i=0;i<devices.length;i++){
            
			var obj=devices[i];
			var trString="";
			trString+="<tr objectId="+obj.objectId+" clientSn="+obj.clientSn+">";
			trString+="<td class='content'><img class='icon' src='"+getClassIcon(obj.classId,appJSON);
            trString+="'></img></td>";
            
			
			trString+="<td class='content'><div>"+
			"<label class='name'>"+obj.name+"</label>";
            
            var tmp_online_icon="img/icon_online.png";
            var tmp_online_content="在线";
            if(obj.netState==0){
                tmp_online_icon="img/icon_offline.png";
                tmp_online_content="离线";
            }
            
            trString+="<img class='onlineImg' src='"+tmp_online_icon+
            "'></img><label class='onlineText'>"+tmp_online_content+"</label>"+
            "</div></td><td class='command'>";
            
            var fieldValues=obj.fieldMap;
            

            
			trString+="</td></tr>";
			
			
			$("#deviceTable").append(trString);
			
			
		}
        load();
		
	}else{
		
		$("#deviceTable").append("<center><span style='width:100%;height:100%;color:#ff0000'>数据为空<span></center>");
		
	}
	
	
	
}
function fieldIsExistInFieldMap(field,fieldMap){
    var isExist=false;
    if(fieldMap==undefined){
        isExist=false;
    }else{
        for(var value in fieldMap){
            if(value==field.fieldId){
                isExist=true;
                break;
            }
        }
    }
    
    return isExist;
}

//从属性列表中找到属性对象值
function findFieldByFieldId(fieldId,fields){
  
    var _field;
    for(var i=0;i<fields.length;i++){
        if(fieldId==fields[i].fieldId){
            _field=fields[i];
            break;
        }
    }
    return _field;
}
function load(){

    
    $("#deviceTable tr").click(function(){
                        
                           $(this).addClass("on").siblings("tr").removeClass("on");

                            hyl_toDetailPage($(this).attr('objectId'),$(this).attr('clientSn'));
                        
                        });
    

    

}




//请求详细设备界面数据信息


function hyl_requestDeviceInfo(){
    if(browser.versions.android){
           window.jna.mobile_requestDeviceInfo();
     }else{
          mobile_requestDeviceInfo();
     }
}
function hyl_register(username,password,repassword){
       if(browser.versions.android){
            window.jna.mobile_registerUserInfo(username,password,repassword);
        }else{
            mobile_registerUserInfo(username,password,repassword);
        }
}
function hyl_requestNeedData(){
            if(browser.versions.android){
                window.jna.mobile_requestNeedData();
            }else{
                mobile_requestNeedData();
            }
}

function hyl_tofindPassPage(){
            if(browser.versions.android){
                window.jna.mobile_tofindPassPage();
            }else{
                 mobile_tofindPassPage();
            }
}
function hyl_toDeviceRegisterPage(){
            if(browser.versions.android){
                window.jna.mobile_toDeviceRegisterPage();
            }else{
                 mobile_toDeviceRegisterPage();
            }
}
function hyl_toWiFiConfigPage(){
            if(browser.versions.android){
                window.jna.mobile_toWiFiConfigPage();
            }else{
                 mobile_toWiFiConfigPage();
            }
}
function hyl_toDeviceDelPage(){
 if(browser.versions.android){
                window.jna.mobile_toDeviceDelPage();
            }else{
                 mobile_toDeviceDelPage();
            }
}


function hyl_findPassCmd(phoneOrEmail){
                if(browser.versions.android){
                     window.jna.mobile_findPassCmd(phoneOrEmail);
                 }else{
                      mobile_findPassCmd(phoneOrEmail);
                 }
}

//设备删除
function hyl_deleteDevice(objectId){
             if(browser.versions.android){
                   window.jna.mobile_deleteDevice(objectId);
              }else{
                   mobile_deleteDevice(objectId);
              }
}
/*
 code : 0代表url地址获取   1代表序列号获取
*/
function hyl_scanCode(code){
     if(browser.versions.android){
                       window.jna.mobile_scanCode(code);
                  }else{
                       mobile_scanCode(code);
                  }
}


function hyl_updateUserInfo(username,email,telephone){
             if(browser.versions.android){
                   window.jna.mobile_updateUserInfo(username,email,telephone);
              }else{
                   mobile_updateUserInfo(username,email,telephone);
              }
}
function hyl_updateUserPass(oldpass,newpass,repass){
              if(browser.versions.android){
                   window.jna.mobile_updateUserPass(oldpass,newpass,repass);
              }else{
                    mobile_updateUserPass(oldpass,newpass,repass);
              }
}

function hyl_downloadApp(url){

              if(browser.versions.android){
                   window.jna.mobile_downloadApp(url);
               }else{
                   mobile_downloadApp(url);
               }
}
/**
 * 注册视频设备
 */
function hyl_registerVideoDevice(sn,uid,username,password,name){
	          if(browser.versions.android){
                   window.jna.mobile_registerVideoDevice(sn,uid,username,password,name);
               }else{
                   mobile_registerVideoDevice(sn,uid,username,password,name);
               }
}
/**
 * 注册设备
 */
function hyl_registerDevice(sn,name){
		  if(browser.versions.android){
                   window.jna.mobile_registerDevice(sn,name);
               }else{
                   mobile_registerDevice(sn,name);
               }	
}

/*
 * 演示APP登陆  loginType 0-智能家居 1-工业控制
*/
function hyl_demoLogin(loginType){
    if(browser.versions.android){
                      window.jna.mobile_demoLogin(loginType);
                  }else{
                      mobile_demoLogin(loginType);
                  }
}

/**
 * 更新设备信息
 */
function hyl_updateDeviceInfo(name,sn,tagArrString){
      if(browser.versions.android){
                        window.jna.mobile_updateDeviceInfo(sn,name,tagArrString);
                    }else{
                        mobile_updateDeviceInfo(sn,name,tagArrString);
                    }
}

function hylSearchClientSn(clientSn){
   if(browser.versions.android){
                           window.jna.mobile_hylSearchClientSn(clientSn);
                       }else{
                           mobile_hylSearchClientSn(clientSn);
                       }
}

function alert(s){
                 if(browser.versions.android){
                       window.jna.malert(s);
                  }else{
                       malert(s);
                  }
}
function findFieldName(clsJson,clsId,fieldId){
  	 var localFieldInfo=[];
  	 var fieldName="*"+fieldId;
  	 for(var i=0;i<clsJson.length;i++){
  	 	 if(clsJson[i].localClsId==clsId){
  	 	 	 localFieldInfo=clsJson[i].localFieldInfo;
  	 	 	 break;
  	 	 }
  	 }
  	 for(var j=0;j<localFieldInfo.length;j++){
  	 	   if(localFieldInfo[j].localFieldId==fieldId){
  	 	   	  fieldName=localFieldInfo[j].localName;
  	 	   	  break;
  	 	   }
  	 }
  	 return fieldName;
  }



  /*
     "0"--数值
     "1"--开关
     "2"--日期
     "3"--货币
     "4"--图像
   */
   function analysisValueFormat(value,type){
     if(type==0){
       return value;
     }else if(type==1){
       if(value==0){
         return "关";
       }else{
         return "开";
       }
     }else if(type==2){
         return ""+value;
     }else if(type==3){
         return "$"+value;
     }else if(type==4){
         return "图像无解析";
     }else{
         return value+type;
     }
   }



/*
*  javascript 处理左右滑动触摸事件
*/

	function reEnableTouchEvent() {
			[].slice.call(document.querySelectorAll('input, select, button,table')).forEach(function(el) {
				el.addEventListener(('ontouchstart' in window) ? 'touchstart' : 'mousedown', function(e) {
					e.stopPropagation();
				})
			})
		}

        function addTouchEvent(dom,moveLeft,moveRight){
             var xx, yy, XX, YY, swipeX, swipeY;
		     var swipeleft=false;
		     dom.addEventListener("touchstart", touchStart, false);
		     dom.addEventListener("touchmove", touchMove, false);
		     dom.addEventListener("touchend", touchEnd, false);

		     function touchEnd(event) {
                  if(swipeX&&swipeY){

                  }else{
                      if(swipeX){
			                if(swipeleft){

			                    moveLeft();
			                  }else{

			                    moveRight();
			                  }
			             }
                  }


			 }

             function touchStart(event) {
			        xx = event.targetTouches[0].screenX;
			        yy = event.targetTouches[0].screenY;
			        swipeX = true;
			        swipeY = true;
		     }
		     function touchMove(event) {
		           	XX = event.targetTouches[0].screenX;
			        YY = event.targetTouches[0].screenY;

			        if (swipeX && Math.abs(XX - xx) - Math.abs(YY - yy) > 0&&Math.abs(XX - xx)>=10) //左右滑动
			        {
				             event.stopPropagation(); //组织冒泡
				             event.preventDefault(); //阻止浏览器默认事件
				             swipeY = false;
                             //左右滑动
			            	 if(XX-xx>0){
				                swipeleft=false;//向右
			            	  }else{
				                swipeleft=true;//向左
			             	  }

			           } else if (swipeY && Math.abs(XX - xx) - Math.abs(YY - yy) < 0) { //上下滑动
				               swipeX = false;//上下滑动，使用浏览器默认的上下滑动

			           }
	               }

        }
function loadNav(numbers,index){
	    	$(".nav_div").remove();
	    	if(numbers==1){
	    		return;
	    	}
	    	var aElements="";
	    	for(var i=0;i<numbers;i++){
	    		if(i==index){
	    		    aElements+="<a class='active'>"+i+"</a>";
	    		}else{
	    			aElements+="<a>"+i+"</a>";
	    		}
	    	}
	    	var navElements="<div class='nav_div'><div class='nav'>"+aElements+"</div></div>";

	    	$("body").append(navElements);

	    }














