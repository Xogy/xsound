var volume = 0.5;
var title = "nothing....";


var yPlayer

function updateName(url){
    if(getYoutubeUrlId(url) === "")
     {
        $("#playing").text("Playing: " + editString(url));
    }else{
        yPlayer = new YT.Player("player",
        {
            height: '0',
            width: '0',
            videoId: getYoutubeUrlId(url),
            events:
            {
                'onReady': function(event){
                    getName(event.target.getVideoData().title);
                    getPic(getYoutubeUrlId(url));
                },
            }
        });
    }
}

function getYoutubeUrlId(url)
{
    var videoId = "";
    if( url.indexOf("youtube") !== -1 ){
        var urlParts = url.split("?v=");
        videoId = urlParts[1].substring(0,11);
    }

    if( url.indexOf("youtu.be") !== -1 ){
        var urlParts = url.replace("//", "").split("/");
        videoId = urlParts[1].substring(0,11);
    }
    return videoId;
}

function editString(string){
    var str = string;
    var res = str.split("/");
    var final = res[res.length - 1];
    final = final.replace(".mp3", " ");
    final = final.replace(".wav", " ");
    final = final.replace(".wma", " ");
    final = final.replace(".wmv", " ");

    final = final.replace(".aac", " ");
    final = final.replace(".ac3", " ");
    final = final.replace(".aif", " ");
    final = final.replace(".ogg", " ");
    final = final.replace("%20", " ");
    final = final.replace("-", " ");

    return final;
}

function getName(name){
     title = name;
     $('#playing').html("Playing: " + title);
     if (this.yPlayer) {
        yPlayer.stopVideo();
        yPlayer.destroy();
     }
}

function getPic(name){
    $("#thumb").attr("src","https://img.youtube.com/vi/"+name+"/0.jpg");
}

var hide = false;

$( "#hide" ).click(function() {
	if(hide){
    $("#main").css({"display":"block"});
    $("#input").css({"display":"block"});
    $(".container").css({"height":"360px"});
    $(".container").css({"opacity":"unset"});
    $("#footer").css({"position":"unset"});
    $("#footer").css({"top":"unset"});
    $("#footer").css({"left":"unset"});
    hide = false
	} else {
    $("#main").css({"display":"none"});
    $("#input").css({"display":"none"});
    $(".container").css({"height":"6%"});
    $(".container").css({"opacity":"50%"});
    $("#footer").css({"position":"absolute"});
    $("#footer").css({"top":"-25px"});
    $("#footer").css({"left":"55px"});
    hide = true
    $.post('https://renzu_mp3/focus', JSON.stringify({}));
  }
});

$( "#play" ).click(function()
{
	var name = $("#url").val();
	if(name.length != 0){
		updateName(name);
    $("#play").css({"display":"none"});
    $("#pause").css({"display":"block"});
		$.post('https://renzu_mp3/play', JSON.stringify(
		{
			url: name,
		}));
	}
});

$( "#pause" ).click(function() {
  $("#play").css({"display":"block"});
  $("#pause").css({"display":"none"});
	$.post('https://renzu_mp3/pause', JSON.stringify({}));
});

$( "#stop" ).click(function()
{
	$.post('https://renzu_mp3/stop', JSON.stringify({}));
	$("#playing").text("Playing: nothing....");
	$("#volume").text("Volume: 50%");
});

$( "#off" ).click(function()
{
	$.post('https://renzu_mp3/exit', JSON.stringify({}));
});

function display(bool) {
    if (bool) {
        $("#body").show();
    } else {
        $("#body").hide();
    }
}

function format(time) {   
  // Hours, minutes and seconds
  var hrs = ~~(time / 3600);
  var mins = ~~((time % 3600) / 60);
  var secs = ~~time % 60;

  // Output like "1:01" or "4:03:59" or "123:03:59"
  var ret = "";
  if (hrs > 0) {
      ret += "" + hrs + ":" + (mins < 10 ? "0" : "");
  }
  ret += "" + mins + ":" + (secs < 10 ? "0" : "");
  ret += "" + secs;
  return ret;
}

$(function(){
	var radio = 0;
    display(false);
	window.addEventListener('message', function(event) {
		var item = event.data;
        if (item.open === "ui"){
            display(item.status);
             $('#playing').html("Playing: " + title);
             //$("#playing").text("Playing:");
             $("#volume").text("Volume: 50%");
        }

        if (item.type === "info"){
            volume = item.volume
            $("#volume").text("Volume: " + Math.floor(volume * 100 ) +"%");
            updateName(item.url);
        }

        if (item.type === "volume"){
            volume = item.volume
            $("#volume").text("Volume: " + Math.floor(volume * 100 ) +"%");
        }

        if (item.type === "duration"){
            duration = item.maxdur
            percentage = item.percentage
            $("#duration").text("" + format(item.setdur) +" / " + format(duration) +"");
            $("#percentage").css({"width":""+percentage+"%"});
        }
		
		if(item.type === "add_default"){
			radio ++;
			$("#menu").append("<div onclick='$(this).playDefault()' class = 'button' value = '"+item.id+"' url = '"+item.url+"'><p>"+radio+"</p></div>");
		}
    })
});

jQuery.fn.extend({
	playDefault: function() {
		var def = $(this).attr('value');
		updateName($(this).attr('url'));
		$.post('https://renzu_mp3/play_default', JSON.stringify({
			radioId: def,
		}));	
	}
});

$( "#plus" ).click(function() {
	$.post('https://renzu_mp3/volumeUp', JSON.stringify({}));
});

$( "#minus" ).click(function() {	
	$.post('https://renzu_mp3/volumeDown', JSON.stringify({}));	
});

function roundNumber(num, scale) {
  if(!("" + num).includes("e")) {
    return +(Math.round(num + "e+" + scale)  + "e-" + scale);
  } else {
    var arr = ("" + num).split("e");
    var sig = ""
    if(+arr[1] + scale > 0) {
      sig = "+";
    }
    return +(Math.round(+arr[0] + "e" + sig + (+arr[1] + scale)) + "e-" + scale);
  }
}