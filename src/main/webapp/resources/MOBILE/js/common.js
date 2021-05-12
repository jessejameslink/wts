var orSign = 0;
$(window).bind('orientationchange',function(e){
    orSign = window.orientation;

    var body = $("body");
    var width = body.width();
    var height = body.height();
    //setTimeout()
    if(orSign == 90 || -90 == orSign){
        orientstyle(width,height)
    }else{
        $(".no_modal").remove();
        $("body").unbind("touchmove");
    }
});
$(window).resize(function(){
    var body = $("body");
    var width = body.width();
    var height = body.height();

    if(orSign == 90 || -90 == orSign){
        orientstyle(width,height)
    }else{
        $(".no_modal").remove();
        $("body").unbind("touchmove");
    }
    //alert(width+"//"+height)
})
function orientstyle(width,height){
    $("body").append("<div class='no_modal'><div>Not support vertical screen</div></div>");
    $("body").bind("touchmove", function(e){e.preventDefault()});

    var orientation = $(".no_modal  div")
    orientation.css("left", ((width / 2) - (orientation.innerWidth() / 2)));
    //alert(width+"//"+height)
}
//common
$(function() {
    var width = screen.availWidth;
    var height = screen.availHeight;
    var widthDoc = $(document).width();
    var heightDoc = $(document).height();
    var heightWin = $(window).height();

    var header_height = $("#header_wrap").height();
    var shadow_height = $(".shadow_box").height();
    var visual_height = $("#visual_wrap").height() / 2;
    var footer_wrap = $("#footer_wrap").height() + 25;

    $('.all_menu').css('height', heightWin);
    $('.menu02').css('width', width - 140);
    $('.all_menu .wrap > ul').css('height', height);
    $('.all_menu').css('left', -width);

    $('.menu').click(function(){
        $(".all_menu").show();
        $("body").append("<div class='menu_modal'></div>");
        $('.all_menu').animate({"left" : "+=" + width + "px"}, {duration:'fast'});
        $("body").addClass("menu_on");
        $("#container_wrap").bind("touchmove", function(e){e.preventDefault()});
        $("body").animate({scrollTop : 0}, 10);
    });

    var allActive = $('.all_menu .wrap .menu01 a');
    allActive.click(function(){
        $(this).addClass('active');
        $(allActive).not(this).removeClass("active");
        $(".all_menu").css("top", "0");
    });

    $('.menu_close').click(function(){
        $(".menu_modal").remove();
        $('.all_menu').animate({"left" : "-=" + width + "px"}, "fast");
        $("body").removeClass('menu_on');
        $("#container_wrap").unbind("touchmove");
        $("#container_wrap").css('position', '');
        $(".all_menu .call_wrap").css('position', 'absolute');
    });
});

/* 메인비주얼 롤링 */
$(window).on('load', function() {
    var width = screen.availWidth;

    if($("#sid_sec img").length > 1){
        rollingHeight   =   $("#sid_sec img")[0].height;

        $('#sid_sec').slidesjs({
            width : width,          //가로
            height : rollingHeight, //세로
            play: {
              active: false,            //이전,다음 버튼 생성(true & false)
              auto: true,           //자동start(true & false)
              effect: "fade",       //효과(slide & false)
              interval: 6000,       //다음걸로 넘어가는 시간
              swap: true,           //플레이,정지버튼 생성(true  & false)
              pauseOnHover: false,  //마우스올라갔을때 정지(true & false)
              restartDelay: 1000    //비활성후 다시 시작시간
            },pagination: {         //동그라미 아이콘, 페이지
              active: true,         //아이콘버튼생성(true & false)
              effect: "fade"        //효과(slide & fade)
            },
            navigation: {
              active: false
            },
            effect: {
              fade: {               //페이드되는 속도
                speed: 1000,
                crossfade: true
              }
            }
        });
    }
});

/* 주가지수 위로 롤링 */
$(function(){
    if($('.stock_box').length) {
        var elems = $('.stock_box'),
            num_elems = elems.length - 1,
            current = 0;

        var animate_out_delay = function() {
            setTimeout(animate_in, 2000);
        }

        var animate_in =function() {
            elems.eq(current).animate({top:-60}, 'slow');
            current = current < num_elems ? current + 1 : 0;
            elems.eq(current).css('top', 60).animate({top:0}, 'slow', animate_out_delay);
        }
        animate_out_delay();
    }
});