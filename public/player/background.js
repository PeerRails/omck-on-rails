/*! videojs-background - v1.0.1 - 2015-06-17
* Copyright (c) 2015 Matthew Harrison-Jones; Licensed MIT */
!function(a,b){"use strict";function c(a,b){var c=g.getElementById(b.id()),d=document.createElement("div");d.setAttribute("class","videojs-background-wrap"),d.appendChild(c),a.container.appendChild(d);var e=document.createElement("style"),f=" .videojs-background-wrap .video-js.vjs-controls-disabled .vjs-poster { position: absolute; top: 0; left:0; width: 100%; height: 100%; background-size: 100%!important; background-size: cover!important; display: block!important; }.videojs-background-wrap .video-js.vjs-has-started .vjs-poster, .videojs-background-wrap .vjs-youtube .vjs-loading-spinner { display: none!important; }";e.setAttribute("type","text/css"),document.getElementsByTagName("head")[0].appendChild(e),e.styleSheet?e.styleSheet.cssText=f:e.appendChild(document.createTextNode(f))}function d(a,b){var c=b.id();if(a.container===i){i.style.height="auto";var d=f.innerHeight>i.clientHeight?"100%":"auto";i.style.height=h.style.height=d}var e=a.container.clientWidth<f.innerWidth?a.container.clientWidth:f.innerWidth,j=a.container.clientHeight<f.innerHeight?a.container.clientHeight:f.innerHeight,k=e/j,l=g.getElementById(c),m=g.getElementById(c+"_"+a.mediaType+"_api");k<a.mediaAspect?(b.width(j*a.mediaAspect),b.height(j),l.style.top="0px",l.style.left=-(j*a.mediaAspect-e)/2+"px",m.style.width=j*a.mediaAspect+"px",m.style.height=j+"px"):(b.width(e),b.height(e/a.mediaAspect),l.style.top=-(e/a.mediaAspect-j)/2+"px",l.style.left="0px",l.style.height=e/a.mediaAspect+"px","html5"===a.mediaType?(m.style.width=m.parentNode.style.width,m.style.height="auto"):(m.style.width=m.parentNode.style.width,m.style.height=e/a.mediaAspect+"px"))}var e,f=a,g=document,h=g.getElementsByTagName("html")[0],i=g.getElementsByTagName("body")[0],j={container:i,autoPlay:!0,mediaAspect:16/9,mediaType:"html5",volume:0};e=function(e){var f=b.util.mergeOptions(j,e),h=this,k=g.getElementById(h.id()+"_"+f.mediaType+"_api");f.container!==i&&"string"==typeof f.container&&(f.container=g.getElementById(f.container)),c(f,h),d(f,h),h.volume(f.volume),f.autoPlay&&h.play(),h.on("loadedmetadata",function(){"html5"===f.mediaType?f.mediaAspect=k.videoWidth/k.videoHeight:void 0!==k.vjs_getProperty&&(f.mediaAspect=k.vjs_getProperty("videoWidth")/k.vjs_getProperty("videoHeight")),d(f,h)}),a.onresize=function(){d(f,h)}},b.plugin("Background",e)}(window,window.videojs);