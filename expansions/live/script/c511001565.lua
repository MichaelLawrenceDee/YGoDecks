--Performage Mirror Conductor
function c511001565.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--lowest atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(511001565)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c511001565.target)
	c:RegisterEffect(e2)
	--switch
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511001565,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c511001565.con)
	e3:SetTarget(c511001565.tg)
	e3:SetOperation(c511001565.op)
	c:RegisterEffect(e3)
	if not c511001565.global_check then
		c511001565.global_check=true
		--register
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_ADJUST)
		ge:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge:SetOperation(c511001565.operation)
		Duel.RegisterEffect(ge,0)
	end
end
function c511001565.target(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
end
function c511001565.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc
end
function c511001565.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local bc=e:GetHandler():GetBattleTarget()
	if chkc then return chkc==bc end
	if chk==0 then return bc:IsOnField() and bc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(bc)
end
function c511001565.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=tc:GetAttack()
		local def=tc:GetDefence()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(def)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENCE_FINAL)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
	end
end
function c511001565.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:GetFlagEffect(511001564)==0 then
			local e1=Effect.CreateEffect(c)	
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetCode(EVENT_ADJUST)
			e1:SetRange(LOCATION_MZONE)
			e1:SetLabel(tc:GetAttack())
			e1:SetOperation(c511001565.op1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetLabel(tc:GetDefence())
			e2:SetOperation(c511001565.op2)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_BASE_ATTACK)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCondition(c511001565.valcon)
			e3:SetValue(c511001565.value)
			e3:SetLabelObject(e1)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetLabelObject(e2)
			e4:SetCode(EFFECT_SET_BASE_DEFENCE)
			tc:RegisterEffect(e4)
			tc:RegisterFlagEffect(511001564,RESET_EVENT+0x1fe0000,0,1) 	
		end	
		tc=g:GetNext()
	end
end
function c511001565.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==c:GetAttack() then return end
	if e:GetLabel()>c:GetAttack() then
		e:SetLabel(c:GetAttack())
	end
end
function c511001565.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==c:GetDefence() then return end
	if e:GetLabel()>c:GetDefence() then
		e:SetLabel(c:GetDefence())
	end
end
function c511001565.valcon(e)
	return e:GetHandler():IsHasEffect(511001565)
end
function c511001565.value(e,c)
	return e:GetLabelObject():GetLabel()
end
