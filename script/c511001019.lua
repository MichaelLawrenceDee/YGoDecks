--シャイニング・リバース
function c511001019.initial_effect(c)
	--Synchro monster, 1 tuner + n or more monsters
	function aux.AddSynchroProcedure(c,f1,f2,ct)
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if f1 then
			mt.tuner_filter=function(mc) return mc and f1(mc) end
		else
			mt.tuner_filter=function(mc) return true end
		end
		if f2 then
			mt.nontuner_filter=function(mc) return mc and f2(mc) end
		else
			mt.nontuner_filter=function(mc) return true end
		end
		mt.minntct=ct
		mt.maxntct=99
		mt.sync=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCondition(Auxiliary.SynCondition(f1,f2,ct,99))
		e1:SetTarget(Auxiliary.SynTarget(f1,f2,ct,99))
		e1:SetOperation(Auxiliary.SynOperation(f1,f2,ct,99))
		e1:SetValue(SUMMON_TYPE_SYNCHRO)
		c:RegisterEffect(e1)
	end
	--Synchro monster, 1 tuner + 1 monster
	function Auxiliary.AddSynchroProcedure2(c,f1,f2)
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if f1 then
			mt.tuner_filter=function(mc) return mc and f1(mc) end
		else
			mt.tuner_filter=function(mc) return true end
		end
		if f2 then
			mt.nontuner_filter=function(mc) return mc and f2(mc) end
		else
			mt.nontuner_filter=function(mc) return true end
		end
		mt.minntct=1
		mt.maxntct=1
		mt.sync=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCondition(Auxiliary.SynCondition(f1,f2,1,1))
		e1:SetTarget(Auxiliary.SynTarget(f1,f2,1,1))
		e1:SetOperation(Auxiliary.SynOperation(f1,f2,1,1))
		e1:SetValue(SUMMON_TYPE_SYNCHRO)
		c:RegisterEffect(e1)
	end
	if c511001603 then --Hot Red Dragon Archfiend King Calamity (Anime)
		local mt=c511001603
		mt.tuner_filter=function(mc) return true end
		mt.nontuner_filter=function(mc) return mc and mc:IsType(TYPE_SYNCHRO) end
		mt.sync=true
		mt.dobtun=true
	end
	if c97489701 then --Red Nova Dragon
		local mt=c97489701
		mt.tuner_filter=function(mc) return true end
		mt.nontuner_filter=function(mc) return mc and mc:IsCode(70902743) end
		mt.sync=true
		mt.dobtun=true
	end
	if c511001637 then --Hot Red Dragon Archfiend Belial (Anime)
		local mt=c511001637
		mt.tuner_filter=function(mc) return true end
		mt.nontuner_filter=function(mc) return true end
		mt.sync=true
		mt.dobtun=true
	end
	if c93157004 then --Vylon Omega
		local mt=c93157004
		mt.tuner_filter=function(mc) return true end
		mt.nontuner_filter=function(mc) return mc and mc:IsSetCard(0x30) end
		mt.sync=true
		mt.dobtun=true
	end
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001019.target)
	e1:SetOperation(c511001019.activate)
	c:RegisterEffect(e1)
end
function c511001019.filter(c,e,tp)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	local tuner=Duel.GetMatchingGroup(c511001019.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local nontuner=Duel.GetMatchingGroup(c511001019.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	if not c:IsType(TYPE_SYNCHRO) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,true) 
		or not mt.sync then return false end
	if c:IsSetCard(0x301) then
		return nontuner:IsExists(c511001019.lvfilter2,1,nil,c,tuner)
	elseif mt.dobtun then
		return mt.syncon and mt.syncon(e,c,nil,nil) and mt.synop
	else
		return tuner:IsExists(c511001019.lvfilter,1,nil,c,nontuner)
	end
end
function c511001019.lvfilter(c,syncard,nontuner)
	local code=syncard:GetOriginalCode()
	local mt=_G["c" .. code]
	local lv=c:GetSynchroLevel(syncard)
	local slv=syncard:GetLevel()
	local nt=nontuner:Filter(Card.IsCanBeSynchroMaterial,nil,syncard,c)
	return mt.minntct and mt.maxntct and nt:CheckWithSumEqual(Card.GetSynchroLevel,slv-lv,mt.minntct,mt.maxntct,syncard)
end
function c511001019.lvfilter2(c,syncard,tuner)
	local code=syncard:GetOriginalCode()
	local mt=_G["c" .. code]
	local lv=c:GetSynchroLevel(syncard)
	local slv=syncard:GetLevel()
	local nt=tuner:Filter(Card.IsCanBeSynchroMaterial,nil,syncard,c)
	return mt.minntct and mt.maxntct and nt:CheckWithSumEqual(Card.GetSynchroLevel,lv+slv,1,1,syncard)
end
function c511001019.matfilter1(c,syncard)
	local code=syncard:GetOriginalCode()
	local mt=_G["c" .. code]
	return c:IsType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
		and mt.tuner_filter and mt.tuner_filter(c)
end
function c511001019.matfilter2(c,syncard)
	local code=syncard:GetOriginalCode()
	local mt=_G["c" .. code]
	return not c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial(syncard) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
		and mt.nontuner_filter and mt.nontuner_filter(c)
end
function c511001019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511001019.filter(chkc) end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return false end
		return Duel.IsExistingTarget(c511001019.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511001019.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c511001019.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c511001019.filter(tc,e,tp) then
		local code=tc:GetOriginalCode()
		local mt=_G["c" .. code]
		local tuner=Duel.GetMatchingGroup(c511001019.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc)
		local nontuner=Duel.GetMatchingGroup(c511001019.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc)
		local mat1
		if tc:IsSetCard(0x301) then
			nontuner=nontuner:Filter(c511001019.lvfilter2,nil,tc,tuner)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			mat1=nontuner:Select(tp,1,1,nil)
			local tlv=mat1:GetFirst():GetSynchroLevel(tc)
			tuner=tuner:Filter(Card.IsCanBeSynchroMaterial,nil,tc,mat1:GetFirst())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local mat2=tuner:SelectWithSumEqual(tp,Card.GetSynchroLevel,tc:GetLevel()+tlv,mt.minntct,mt.maxntct,tc)
			mat1:Merge(mat2)
		elseif mt.dobtun then
			if mt.synop then
				mt.synop(e,tp,eg,ep,ev,re,r,rp,tc,nil,nil)
			else return end
		else
			tuner=tuner:Filter(c511001019.lvfilter,nil,tc,nontuner)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			mat1=tuner:Select(tp,1,1,nil)
			local tlv=mat1:GetFirst():GetSynchroLevel(tc)
			nontuner=nontuner:Filter(Card.IsCanBeSynchroMaterial,nil,tc,mat1:GetFirst())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local mat2=nontuner:SelectWithSumEqual(tp,Card.GetSynchroLevel,tc:GetLevel()-tlv,mt.minntct,mt.maxntct,tc)
			mat1:Merge(mat2)
		end
		if not mt.dobtun then
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
		end
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		tc:CompleteProcedure()
	end
end
