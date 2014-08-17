/*
 * lightIRC configuration
 * www.lightIRC.com
 *
 * You can add or change these parameters to customize lightIRC.
 * Please see the full parameters list at http://redmine.lightirc.com/projects/lightirc/wiki/Customization_parameters
 *
 */

var params = {};

/* Change these parameters */
params.host                         = "irc.canternet.org";
params.port                         = 6667;
params.policyPort                   = 843;

/* Language for the user interface. Currently available translations: ar, bd, bg, br, cz, da, de, el, en, es, et, fi, fr, hu, hr, id, it, ja, lv, nl, no, pl, pt, ro, ru, sk, sl, sq, sr_cyr, sr_lat, sv, th, tr, uk */
params.language                     = "ru";

/* Relative or absolute URL to a lightIRC CSS file.
 * The use of styles only works when you upload lightIRC to your webspace.
 * Example: css/lightblue.css 
 */
params.styleURL                     = "";

/* Nick to be used. A % character will be replaced by a random number */
params.nick                         = "Dwarf_%";
/* Channel to be joined after connecting. Multiple channels can be added like this: #lightIRC,#test,#help */
params.autojoin                     = "#omcktv";
/* Commands to be executed after connecting. E.g.: /mode %nick% +x */
params.perform                      = "";

/* Whether the server window (and button) should be shown */
params.showServerWindow             = true;

/* Show a popup to enter a nickname */
params.showNickSelection            = true;
/* Adds a password field to the nick selection box */
params.showIdentifySelection        = true;

/* Show button to register a nickname */
params.showRegisterNicknameButton   = true;
/* Show button to register a channel */
params.showRegisterChannelButton    = false;

/* Opens new queries in background when set to true */
params.showNewQueriesInBackground   = false;

/* Position of the navigation container (where channel and query buttons appear). Valid values: left, right, top, bottom */
//params.navigationPosition           = "bottom";
params.rememberNickname				= true;
params.showNavigation				= true;
params.soundAlerts					= false;
params.showListButton				= false;
params.showEmoticonsButton			= false;
params.channelHeader 				= "%topic% (%users% участников) [%mode%]";
params.userListWidth 				= 0;
params.showInfoMessages				= true;
params.showJoinPartMessages			= false;
params.showTimestamps				= false;
params.quitMessage					= 'Встал и ушел';
params.emoticonList = ":kebab:->kebab.png,"+
":doge:->doge.png,"+
":breivik:->breivik.png,"+
":antifa:->antifa.png,"+
":peer:->jew.png,"+
":spurdo:->spurdo.png,"+
":yoba:->yoba.png,"+
"kappa->kappa.png,"+
":feel:->feel.png,"+
":kira:->kira.png,"+
":drake:->drake.png,"+
":sanic:->sanic.png,"+
":megaman:->megaman.png,"+
":arino:->arino.png,"+
":dwarf:->dwarf.png,"+
":pyro:->pyro.png,"+
":cf:->cf.png,"+
":frost:->frost.png,"+
":dolan:->dolan.png,"+
":dosh:->dosh.png,"+
":feelsgood:->feelsgood.png,"+
":fuckyou:->fuckyou.png,"+
":donte:->fuckyou.png,"+
":gaben:->gaben.gif,"+
":gay:->gay.gif,"+
":jimmies:->jimmes.gif,"+
":nintendo:->ninte.png,"+
":ogre:->ogre.png,"+
":mmm:->oops.gif,"+
":pomf:->pomf.png,"+
":sphere:->sphere.png,"+
":stanza:->stanza.png,"+
":nigga:->nigga.png,"+
":ainsley:->nigga.png,"+
":420:->weed.gif,"+
":why:->why.png"+
":dick:->dick.png,"+
":allah:->allah.png,"+
":cat:->cat.png,"+
":animu:->animu.png,"+
":anime:->animu.png,"+
":chen:->chen.png,"+
":bomb:->bomb.png,"+
":jc:->bomb.png,"+
":dog:->dog.gif,"+
":bunny:->asstits.gif,"+
":dcp:->dcp.gif,"+
":mgs3:->bigboss.png,"+
":dew:->dew.jpg,"+
":ozon:->ozon.jpg,"+
":dcp:->dcp.gif,"+
":dick:->dick.jpg,"+
":mami:->mami.jpg,"+
":clusty:->sambuka2.jpg,"+
":why:->why1.png";

params.identifyCommand				= '/msg NickServ IDENTIFY %pass%';
params.registerNicknameCommand		= '/msg NickServ REGISTER %password% %mail%';
params.identifyMessage = "";


/* See more parameters at http://redmine.lightirc.com/projects/lightirc/wiki/Customization_parameters */




/* Use this method to send a command to lightIRC with JavaScript */
function sendCommand(command) {
  swfobject.getObjectById('lightIRC').sendCommand(command);
}

/* Use this method to send a message to the active chatwindow */
function sendMessageToActiveWindow(message) {
  swfobject.getObjectById('lightIRC').sendMessageToActiveWindow(message);
}

/* Use this method to set a random text input content in the active window */
function setTextInputContent(content) {
  swfobject.getObjectById('lightIRC').setTextInputContent(content);
}

/* This method gets called if you click on a nick in the chat area */
function onChatAreaClick(nick, ident, realname, channel, host) {
  //alert("onChatAreaClick: "+nick);
}

/* This method gets called if you use the parameter contextMenuExternalEvent */
function onContextMenuSelect(type, nick, ident, realname, channel, host) {
  alert("onContextMenuSelect: "+nick+" for type "+type);
}

/* This method gets called if you use the parameter loopServerCommands */
function onServerCommand(command) {
  return command;
}

/* This method gets called if you use the parameter loopClientCommands */
function onClientCommand(command) {
  return command;
}

/* This event ensures that lightIRC sends the default quit message when the user closes the browser window */
window.onbeforeunload = function() {
  swfobject.getObjectById('lightIRC').sendQuit();
}

/* This loop escapes % signs in parameters. You should not change it */
for(var key in params) {
  params[key] = params[key].toString().replace(/%/g, "%25");
}