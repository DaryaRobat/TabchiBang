-----@NoFooZiTM-@GounGm-----
DTBS = (loadfile "DTBS.lua")()
-----------------------------
DTBS = DTBS.connect('127.0.0.1', 6379)
-----------------------------
local TBCHI = BANG-ID
admin = 374668345 -- ID sudo
-----------------------------
channel_id = DTBS:get('nofoozi'..TBCHI..'channel_id')
channel_user = DTBS:get('nofoozi'..TBCHI..'channel_user')
--------------------------------------
function dl_cb(arg, data)
end
function Check_Info ()
	if not channel_id then
		while not channel_id do
			print("\n\27[36m                      @NoFooZiTM \n >> Channel Id :\n\27[31m                 ")
			channel_id=io.read("*n")
		end
		DTBS:set('nofoozi'..TBCHI..'channel_id', channel_id)
		print("\n\27[36m     channel id |\27[32m ".. channel_id .." \27[36m")
	end
	if (not channel_user or channel_user == "") then
		while (not channel_user or channel_user == "") do
			print("\n\27[36m                      @NoFooZiTM \n >> Channel Username :\n\27[31m                 ")
			channel_user = io.read()
		end
		DTBS:set('nofoozi'..TBCHI..'channel_user', channel_user)
		print("\n\27[36m     channel_user |\27[32m ".. channel_user .." \27[36m")
	end
end
-----------------------------
function get_bot (i, sami)
	function bot_info (i, sami)
		DTBS:set("nofoozi"..TBCHI.."id",sami.id_)
		if sami.first_name_ then
			DTBS:set("nofoozi"..TBCHI.."fname",sami.first_name_)
		end
		if sami.last_name_ then
			DTBS:set("nofoozi"..TBCHI.."lanme",sami.last_name_)
		end
		DTBS:set("nofoozi"..TBCHI.."num",sami.phone_number_)
		return sami.id_
	end
	tdcli_function ({ID = "GetMe",}, bot_info, nil)
end
-----------------------------
function is_sami(msg)
    local var = false
	local hash = 'nofoozi'..TBCHI..'admin'
	local user = msg.sender_user_id_
    local sami = DTBS:sismember(hash, user)
	if sami then
		var = true
	end
	return var
end
-----------------------------
function writefile(filename, input)
	local file = io.open(filename, "w")
	file:write(input)
	file:flush()
	file:close()
	return true
end
-----------------------------
function process_join(i, sami)
	if sami.code_ == 429 then
		local message = tostring(sami.message_)
		local Time = message:match('%d+') + 85
		DTBS:setex("nofoozi"..TBCHI.."maxjoin", tonumber(Time), true)
	else
		DTBS:srem("nofoozi"..TBCHI.."goodlinks", i.link)
		DTBS:sadd("nofoozi"..TBCHI.."savedlinks", i.link)
	end
end
function process_link(i, sami)
	if (sami.is_group_ or sami.is_supergroup_channel_) then
		DTBS:srem("nofoozi"..TBCHI.."waitelinks", i.link)
		DTBS:sadd("nofoozi"..TBCHI.."goodlinks", i.link)
	elseif sami.code_ == 429 then
		local message = tostring(sami.message_)
		local Time = message:match('%d+') + 85
		DTBS:setex("nofoozi"..TBCHI.."maxlink", tonumber(Time), true)
	else
		DTBS:srem("nofoozi"..TBCHI.."waitelinks", i.link)
	end
end
function find_link(text)
	if text:match("https://telegram.me/joinchat/%S+") or text:match("https://t.me/joinchat/%S+") or text:match("https://telegram.dog/joinchat/%S+") then
		local text = text:gsub("t.me", "telegram.me")
		local text = text:gsub("telegram.dog", "telegram.me")
		for link in text:gmatch("(https://telegram.me/joinchat/%S+)") do
			if not DTBS:sismember("nofoozi"..TBCHI.."alllinks", link) then
				DTBS:sadd("nofoozi"..TBCHI.."waitelinks", link)
				DTBS:sadd("nofoozi"..TBCHI.."alllinks", link)
			end
		end
	end
end
-----------------------------
function add(id)
	local Id = tostring(id)
	if not DTBS:sismember("nofoozi"..TBCHI.."all", id) then
		if Id:match("^(%d+)$") then
			DTBS:sadd("nofoozi"..TBCHI.."users", id)
			DTBS:sadd("nofoozi"..TBCHI.."all", id)
		elseif Id:match("^-100") then
			DTBS:sadd("nofoozi"..TBCHI.."supergroups", id)
			DTBS:sadd("nofoozi"..TBCHI.."all", id)
		else
			DTBS:sadd("nofoozi"..TBCHI.."groups", id)
			DTBS:sadd("nofoozi"..TBCHI.."all", id)
		end
	end
	return true
end
function rem(id)
	local Id = tostring(id)
	if DTBS:sismember("nofoozi"..TBCHI.."all", id) then
		if Id:match("^(%d+)$") then
			DTBS:srem("nofoozi"..TBCHI.."users", id)
			DTBS:srem("nofoozi"..TBCHI.."all", id)
		elseif Id:match("^-100") then
			DTBS:srem("nofoozi"..TBCHI.."supergroups", id)
			DTBS:srem("nofoozi"..TBCHI.."all", id)
		else
			DTBS:srem("nofoozi"..TBCHI.."groups", id)
			DTBS:srem("nofoozi"..TBCHI.."all", id)
		end
	end
	return true
end
-----------------------------
function SendMsg(chat_id, msg_id, text)
	 tdcli_function ({
    ID = "SendChatAction",
    chat_id_ = chat_id,
    action_ = {
      ID = "SendMessageTypingAction",
      progress_ = 100
    }
  }, cb or dl_cb, cmd)
	tdcli_function ({
		ID = "SendMessage",
		chat_id_ = chat_id,
		reply_to_message_id_ = msg_id,
		disable_notification_ = 1,
		from_background_ = 1,
		reply_markup_ = nil,
		input_message_content_ = {
			ID = "InputMessageText",
			text_ = text,
			disable_web_page_preview_ = 1,
			clear_draft_ = 0,
			entities_ = {},
			parse_mode_ = {ID = "TextParseModeHTML"},
		},
	}, dl_cb, nil)
end
-----------------------------
Check_Info()
DTBS:set("nofoozi"..TBCHI.."start", true)
function OffExpire(msg, data)
	SendMsg(msg.chat_id_, msg.id_, "<i>سلااااام من ان شدمممم</i>")
end
-----------------------------
function tdcli_update_callback(data)
	if data.ID == "UpdateNewMessage" then
		if DTBS:get("nofoozi"..TBCHI.."OFFTIME") then
			return
		end
		if not DTBS:get("nofoozi"..TBCHI.."maxlink") then
			if DTBS:scard("nofoozi"..TBCHI.."waitelinks") ~= 0 then
				local links = DTBS:smembers("nofoozi"..TBCHI.."waitelinks")
				for x,y in ipairs(links) do
					if x == 6 then DTBS:setex("nofoozi"..TBCHI.."maxlink", 70, true) return end
					tdcli_function({ID = "CheckChatInviteLink",invite_link_ = y},process_link, {link=y})
				end
			end
		end
		if not DTBS:get("nofoozi"..TBCHI.."maxjoin") then
			if DTBS:scard("nofoozi"..TBCHI.."goodlinks") ~= 0 then
				local links = DTBS:smembers("nofoozi"..TBCHI.."goodlinks")
				for x,y in ipairs(links) do
					tdcli_function({ID = "ImportChatInviteLink",invite_link_ = y},process_join, {link=y})
					if x == 2 then DTBS:setex("nofoozi"..TBCHI.."maxjoin", 70, true) return end
				end
			end
		end
		local msg = data.message_
		local bot_id = DTBS:get("nofoozi"..TBCHI.."id") or get_bot()
		if (msg.sender_user_id_ == 777000 or msg.sender_user_id_ == 178220800) then
			local c = (msg.content_.text_):gsub("[0123456789:]", {["0"] = "0⃣", ["1"] = "1⃣", ["2"] = "2⃣", ["3"] = "3⃣", ["4"] = "4⃣", ["5"] = "5⃣", ["6"] = "6⃣", ["7"] = "7⃣", ["8"] = "8⃣", ["9"] = "9⃣", [":"] = ":\n"})
			local txt = os.date("<b>=>New Msg From Telegram</b> : <code> %Y-%m-%d </code>")
			for k,v in ipairs(DTBS:smembers('nofoozi'..TBCHI..'admin')) do
				SendMsg(v, 0, txt.."\n\n"..c)
			end
		end
		if tostring(msg.chat_id_):match("^(%d+)") then
			if not DTBS:sismember("nofoozi"..TBCHI.."all", msg.chat_id_) then
				DTBS:sadd("nofoozi"..TBCHI.."users", msg.chat_id_)
				DTBS:sadd("nofoozi"..TBCHI.."all", msg.chat_id_)
			end
		end
		add(msg.chat_id_)
		if msg.date_ < os.time() - 150 then
			return false
		end
-----------------------------
		if msg.content_.ID == "MessageText" then
    if msg.chat_id_ then
      local id = tostring(msg.chat_id_)
      if id:match('-100(%d+)') then
        chat_type = 'super'
        elseif id:match('^(%d+)') then
        chat_type = 'user'
        else
        chat_type = 'group'
        end
      end
			local text = msg.content_.text_
			local matches
			if DTBS:get("nofoozi"..TBCHI.."link") then
				find_link(text)
			end
	if text and text:match('[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM]') then
		text = text:lower()
		end
--4829----TexTs-------12242
local Help = [[

••راهنمای ربات تبچی••

<code>Share</code>
دریافت شماره ربات

<code>fwd</code>
فوروارد بنر شما توسط ربات

<code>force off</code>
خاموش کردن جوین اجباری

<code>force on</code>
روشن کردن جوین اجباری

<code>sleep number</code>
خاموش شدن ربات برای مدت زمان دلخواه شما

<code>set sudo ID</code>
افزودن مدیر به ربات

<code>rem sudo ID</code>
حذف مدیر ربات

<code>add all ID</code>
افزودن کاربر به تمام گروه های ربات

<code>left gp</code>
لفت از تمام گروه ها

<code>letf sgp</code>
لفت از تمام سوپر گروه ها

<code>reload</code>
ریلود کردن ربات

<code>join on</code>
فعال کردن جوین

<code>join off</code>
خاموش کردن جوین

<code>rst stats</code>
تازه سازی امار ربات

<code>ping</code>
اطلاع از انلاینی ربات

<code>stats</code>
دریافت امار ربات

@NoFooZiTM-@GounGm

]]
local Fwd1 = "در حال ارسال ..\nدر هر [TIME] ثانیه پیام شما به [GPSF] گروه ارسال میشود .\nتا تموم شدن کار دستور نده بهم \nتاتموم شدن کار [ALL] ثانیه طوا میکشه\n[ MINدقیقه]\n[H ساعت ]"
local Fwd2 = "فوروارد شد"
local Done = "<i>حله</i>"
local Reload = "حل شد\nفایل [BANG"..TBCHI..".lua] ریلود شد"
local off = "حل شد\nربات واس [TIME] ثانیه خاموش شد"
local forcejointxt = {'اول باید تو کانالم جوین بدی\nایدی کانالم :\n'..channel_user,'هنوز جوین نشدی تو چنلم\nاول جوین شو بعد بیا بچتیم\nایدی کانالم :\n'..channel_user,'اول باید تو کانالم جوین شی\nاومدی بگو\nایدی کانالم :\n'..channel_user}
local forcejoin = forcejointxt[math.random(#forcejointxt)]
local joinon = "غیر فعال"
local joinoff = "غیر فعال شد"
local info = [[

@NoFooZiTM-@GounGm●•

]]
local addtime = {15,16,17,18,19,20,21,23,22,24,25}
local a = addtime[math.random(#addtime)]
local addrandomtime = a
local agpstime = {3,4,5,6,7}
local b = agpstime[math.random(#agpstime)]
local agpsrandom = b
local all = tostring(DTBS:scard("nofoozi"..TBCHI.."groups")) + tostring(DTBS:scard("nofoozi"..TBCHI.."supergroups"))
local eend = ( all / agpsrandom ) * addrandomtime - addrandomtime
local Addall1 = "درحال افزودن ...\nزمانبندی : در هر [SLEEP] ثانیه کاربر به [GP] گروه دعوت می شود !\nتا پایان این عملیات [END] ثانیه زمان صرف میشود و ربات تا پایان این عملیات پاسخگوی دستورات شما نخواهد بود \n@NoFooZiTM-@GounGm"
local Addall2 = "کارم تموم شد داش حرفی داشتی بزن"
local sendtime = {25,30,33,35,40,41,42,43,44,45,50,51,52,53,54,55,60}
local nofoozitm = sendtime[math.random(#sendtime)]
local randomtime = nofoozitm
local gpstime = {3,4,5,6,7}
local samibang = gpstime[math.random(#gpstime)]
local gpsrandom = samibang
local Fwd1 = "درحال فروارد !\nزمانبندی : در هر [TIME] ثانیه پیام به [RG] گروه ارسال میشود .\nتا پایان این عملیات [END] ثانیه زمان صرف میشود و ربات تا پایان این عملیات پاسخگوی دستورات شما نخواهد بود \n@NoFooZiTM-@GounGm"
local Fwd2 = "فوروارد تموم شد داش کار داشتی بگو"
local demsudo = "این جاکش از مقام مدیری سیک شد"
local setsudo = "این یارو کیرمم نیست چه برسه به مدیر"
local rs = "امار ربات ریست شد"
local forceon = "فعال شد"
local forceoff = "غیر فعال شد"
local gpleave = "ربات از [GP] گپ لفتید"
local sgpleave = "ربات از  [SGP] سوپر گپ لفتید"
local Online = "<code> Bot Is Online •●@NoFooZiTM-@GounGm●• </code>"
------------------
		if chat_type == 'user' then
local sami = DTBS:get('nofoozi'..TBCHI..'forcejoin')
if sami then
if text:match('(.*)') then
function checmember_cb(ex,res)
      if res.ID == "ChatMember" and res.status_ and res.status_.ID and res.status_.ID ~= "ChatMemberStatusMember" and res.status_.ID ~= "ChatMemberStatusEditor" and res.status_.ID ~= "ChatMemberStatusCreator" then
      return SendMsg(msg.chat_id_, msg.id_,forcejoin)
      else
return
end
end
end
else
if text:match('(.*)') then
return
end
end
tdcli_function ({ID = "GetChatMember",chat_id_ = channel_id, user_id_ = msg.sender_user_id_}, checmember_cb, nil)
    end
----------@NoFooZiTM----------
			if is_sami(msg) then
				find_link(text)
----------@NoFooZiTM----------
								if text:match("^([Ss]leep) (%d+)$") then
					local matches = tonumber(text:match("%d+"))
					DTBS:setex('nofoozi'..TBCHI..'OFFTIME', matches, true)
					tdcli_function ({
					ID = "SetAlarm",
					seconds_ = matches
					}, OffExpire, msg)
					local text = off:gsub("TIME",matches)
					return SendMsg(msg.chat_id_, msg.id_, text)
----------@NoFooZiTM----------
				elseif text:match("^([Ss]et [Ss]udo) (%d+)$") then
					local matches = text:match("%d+")
					if DTBS:sismember('nofoozi'..TBCHI..'admin', matches) then
						return SendMsg(msg.chat_id_, msg.id_, "<i>مدیر شد این جاکش</i>")
					elseif DTBS:sismember('nofoozi'..TBCHI..'mod', msg.sender_user_id_) then
						return SendMsg(msg.chat_id_, msg.id_, "'گوه نخور داش'")
					else
						DTBS:sadd('nofoozi'..TBCHI..'admin', matches)
						DTBS:sadd('nofoozi'..TBCHI..'mod', matches)
						return SendMsg(msg.chat_id_, msg.id_, setsudo)
					end
----------@NoFooZiTM----------
				elseif text:match("^([Rr]em [Ss]udo) (%d+)$") then
					local matches = text:match("%d+")
					if DTBS:sismember('nofoozi'..TBCHI..'mod', msg.sender_user_id_) then
						if tonumber(matches) == msg.sender_user_id_ then
								DTBS:srem('nofoozi'..TBCHI..'admin', msg.sender_user_id_)
								DTBS:srem('nofoozi'..TBCHI..'mod', msg.sender_user_id_)
							return SendMsg(msg.chat_id_, msg.id_, "از الان نه تنها مدیر نیستی بلکه کیرمم نیستی")
						end
						return SendMsg(msg.chat_id_, msg.id_, "گوه نخور داش")
					end
					if DTBS:sismember('nofoozi'..TBCHI..'admin', matches) then
						if  DTBS:sismember('nofoozi'..TBCHI..'admin'..msg.sender_user_id_ ,matches) then
							return SendMsg(msg.chat_id_, msg.id_, "تو نمیتونی گوه گنده تر از دهنت بخوری")
						end
						DTBS:srem('nofoozi'..TBCHI..'admin', matches)
						DTBS:srem('nofoozi'..TBCHI..'mod', matches)
						return SendMsg(msg.chat_id_, msg.id_, demsudo)
					end
					return SendMsg(msg.chat_id_, msg.id_, "این یارو ادمین نی")
----------@NoFooZiTM----------
	elseif text:match("^([Rr]eload)$") then
       dofile('./BANG-'..TBCHI..'.lua')
 return SendMsg(msg.chat_id_, msg.id_, Reload)
----------@NoFooZiTM----------
 elseif text:match("^([Hh]elp)$") then
 return SendMsg(msg.chat_id_, msg.id_, Help)
 ----------@NoFooZiTM----------
 elseif text:match("^([Ff]orce [Oo]n)$") then
 DTBS:set("nofoozi"..TBCHI.."[Ff]orce", true)
 return SendMsg(msg.chat_id_, msg.id_, forceon)
 ----------@NoFooZiTM----------
 elseif text:match("^([Ff]orce [Oo]ff)$") then
 DTBS:del('nofoozi'..TBCHI..'[Ff]orce')
 return SendMsg(msg.chat_id_, msg.id_, forceoff)
 ----------@NoFooZiTM----------
 elseif text:match("^([Jj]oin [Oo]n)$") then
DTBS:del("nofoozi"..TBCHI.."maxjoin")
DTBS:del("nofoozi"..TBCHI.."offjoin")
DTBS:set("nofoozi"..TBCHI.."link", true)
 return SendMsg(msg.chat_id_, msg.id_, joinon)
 ----------@NoFooZiTM----------
 elseif text:match("^([Jj]oin [Oo]ff)$") then
DTBS:set("nofoozi"..TBCHI.."maxjoin", true)
DTBS:set("nofoozi"..TBCHI.."offjoin", true)
--#lakjshxnhasg
DTBS:del("nofoozi"..TBCHI.."link")
 return SendMsg(msg.chat_id_, msg.id_, joinoff)
----------@NoFooZiTM----------
				elseif (text:match("^([Pp]ing)$") and not msg.forward_info_)then
					 return SendMsg(msg.chat_id_, msg.id_, Online)
----------@NoFooZiTM----------
					elseif text:match("^([Rr]st [Ss]tats)$")then
					local list = {DTBS:smembers("nofoozi"..TBCHI.."supergroups"),DTBS:smembers("nofoozi"..TBCHI.."groups"),DTBS:smembers("nofoozi"..TBCHI.."users")}
				tdcli_function({
						ID = "SearchContacts",
						query_ = nil,
						limit_ = 999999999
					}, function (i, sami)
						DTBS:set("nofoozi"..TBCHI.."contacts", sami.total_count_)
					end, nil)
					for i, v in ipairs(list) do
							for a, b in ipairs(v) do
								tdcli_function ({
									ID = "GetChatMember",
									chat_id_ = b,
									user_id_ = bot_id
								}, function (i,sami)
									if  sami.ID == "Error" then rem(i.id)
									end
								end, {id=b})
							end
					end
					 SendMsg(msg.chat_id_, msg.id_, rs)
----------@NoFooZiTM----------
					elseif text:match("^([Ss]hare)$") then
					      get_bot()
					local fname = DTBS:get("nofoozi"..TBCHI.."fname")
					local lnasme = DTBS:get("nofoozi"..TBCHI.."lname") or ""
					local num = DTBS:get("nofoozi"..TBCHI.."num")
					tdcli_function ({
						ID = "SendMessage",
						chat_id_ = msg.chat_id_,
						reply_to_message_id_ = msg.id_,
						disable_notification_ = 1,
						from_background_ = 1,
						reply_markup_ = nil,
						input_message_content_ = {
							ID = "InputMessageContact",
							contact_ = {
								ID = "Contact",
								phone_number_ = num,
								first_name_ = fname,
								last_name_ = lname,
								user_id_ = bot_id
							},
						},
					}, dl_cb, nil)
----------@NoFooZiTM----------
					elseif text:match("^([Ss]tats)$") then
					get_bot()
				local botname = DTBS:get("nofoozi"..TBCHI.."fname")
local botphone = DTBS:get("nofoozi"..TBCHI.."num")
local botuser = DTBS:get("nosfoozi"..TBCHI.."id")
local offjoin = DTBS:get("nofoozi"..TBCHI.."offjoin") and "غیرفعال" or "فعال"
local forcejoin = DTBS:get("nofoozi"..TBCHI.."forcejoin") and "فعال" or "غیرفعال"
local gps = tostring(DTBS:scard("nofoozi"..TBCHI.."groups"))
local sgps = tostring(DTBS:scard("nofoozi"..TBCHI.."supergroups"))
local links = tostring(DTBS:scard("nofoozi"..TBCHI.."savedlinks"))
local glinks = tostring(DTBS:scard("nofoozi"..TBCHI.."goodlinks"))
local usrs = tostring(DTBS:scard("nofoozi"..TBCHI.."users"))
local text = [[

•● آمار ربات شما ●•

●• <code>پیوی ها </code> : ]]  .. tostring(usrs) ..  [[


●• <code>گپ ها </code>  : ]]  .. tostring(gps) ..  [[


●• <code>سوپر گپ ها</code>  : ]]  .. tostring(sgps) ..  [[


●• <code>تعداد لینک ها</code>  : ]]  .. tostring(links)..  [[


●• <code>وضعیت جوین</code>  : ]]  .. tostring(offjoin)..  [[


●• <code>جوین اجباری</code>  : ]]  .. tostring(forcejoin)..  [[


●• <code> کانال</code> : ]] .. tostring(channel_user)


return SendMsg(msg.chat_id_, msg.id_, text)
----------@NoFooZiTM----------
			elseif (text:match("^([Ff]wd)$") and msg.reply_to_message_id_ ~= 0) then
     			local all = tostring(DTBS:scard("nofoozi"..TBCHI.."all"))
				local sami = "nofoozi"..TBCHI.."all"
					local endtime = ( all / gpsrandom ) * randomtime - randomtime
						local text = Fwd1:gsub("TIME",randomtime):gsub("END",endtime):gsub("RG",gpsrandom)
				SendMsg(msg.chat_id_, msg.id_, text)
					local list = DTBS:smembers(sami)
					local id = msg.reply_to_message_id_
						for i, v in pairs(list) do
							tdcli_function({
								ID = "ForwardMessages",
								chat_id_ = v,
								from_chat_id_ = msg.chat_id_,
								message_ids_ = {[0] = id},
								disable_notification_ = 1,
								from_background_ = 1
							}, dl_cb, nil)
							if i % gpsrandom == 0 then
								os.execute("sleep "..randomtime.."")
							end
							end
						return SendMsg(msg.chat_id_, msg.id_, Fwd2)
----------@NoFooZiTM----------
	elseif text:match("^([Aa]dd [Aa]ll) (%d+)$") then
					local matches = text:match("%d+")
					local text = Addall1:gsub("SLEEP",addrandomtime):gsub("GP",agpsrandom):gsub("END",eend)
						SendMsg(msg.chat_id_, msg.id_, text)
					local list = {DTBS:smembers("nofoozi"..TBCHI.."groups"),DTBS:smembers("nofoozi"..TBCHI.."supergroups")}
					for a, b in pairs(list) do
						for i, v in pairs(b) do
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = matches,
								forward_limit_ =  50
							}, dl_cb, nil)
								if i % agpsrandom == 0 then
								os.execute("sleep "..addrandomtime.."")
						end
						end
					    end
					return SendMsg(msg.chat_id_, msg.id_, Addall2)
----------@NoFooZiTM----------
					elseif text:match("^[Ll]ft [Ss]gp") then
					   function lkj(arg, data)
						bot_id=data.id_
						local list = DTBS:smembers('nofoozi'..TBCHI..'supergroups')
						for k,v in pairs(list) do
						DTBS:srem('nofoozi'..TBCHI..'supergroups',v)
						print(v)
						tdcli_function ({
							ID = "ChangeChatMemberStatus",
							chat_id_ = v,
							user_id_ = bot_id,
							status_ = {
							  ID = "ChatMemberStatusLeft"
							},
						  }, dl_cb, nil)
						end
						end
				tdcli_function({ID="GetMe",},lkj, nil)
				           local sgps = tostring(DTBS:scard("nofoozi"..TBCHI.."supergroups"))
				                    local text = sgpleave:gsub("SGP",sgps)
									return SendMsg(msg.chat_id_, msg.id_, text)
----------@NoFooZiTM-------------------------------------
							elseif text:match("^[Ll]ft [Gg]p") then
					   function lkj(arg, data)
						bot_id=data.id_
						local list = DTBS:smembers('nofoozi'..TBCHI..'groups')
						for k,v in pairs(list) do
						DTBS:srem('nofoozi'..TBCHI..'groups',v)
						print(v)
						tdcli_function ({
							ID = "ChangeChatMemberStatus",
							chat_id_ = v,
							user_id_ = bot_id,
							status_ = {
							  ID = "ChatMemberStatusLeft"
							},
						  }, dl_cb, nil)
						end
						end
				tdcli_function({ID="GetMe",},lkj, nil)
				        local gps = tostring(DTBS:scard("nofoozi"..TBCHI.."groups"))
				              local text = gpleave:gsub("GP",gps)
									return SendMsg(msg.chat_id_, msg.id_, text)
-----------@NoFooZiTM----------
				end
					 end
		elseif msg.content_.ID == "MessageChatDeleteMember" and msg.content_.id_ == bot_id then
			return rem(msg.chat_id_)
		elseif (msg.content_.caption_ and DTBS:get("nofoozi"..TBCHI.."link"))then
			find_link(msg.content_.caption_)
		end
		if DTBS:get("nofoozi"..TBCHI.."markread") then
			tdcli_function ({
				ID = "ViewMessages",
				chat_id_ = msg.chat_id_,
				message_ids_ = {[0] = msg.id_}
			}, dl_cb, nil)
		end
	elseif data.ID == "UpdateOption" and data.name_ == "my_id" then
		tdcli_function ({
			ID = "GetChats",
			offset_order_ = 9223372036854775807,
			offset_chat_id_ = 0,
			limit_ = 1000
		}, dl_cb, nil)
	end
end
