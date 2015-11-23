--Rebellion
function c511001109.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511001109.target)
	e1:SetOperation(c511001109.activate)
	c:RegisterEffect(e1)
end
function c511001109.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c511001109.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(511001109,RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END,0,0)
		if Duel.GetFlagEffect(tp,511001110)~=0 then return end
		--attack!
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(c511001109.atkcon)
		e1:SetOperation(c511001109.atkop)
		e1:SetRange(0xff)
		e1:SetReset(RESET_PHASE+RESET_END)
		c:RegisterEffect(e1)
		Duel.RegisterFlagEffect(tp,511001110,RESET_PHASE+PHASE_END,0,1)
	end
end
function c511001109.filter(c)
	return c:GetFlagEffect(511001109)>0 and (c:IsHasEffect(EFFECT_CANNOT_ATTACK) or c:IsHasEffect(EFFECT_CANNOT_ATTACK_ANNOUNCE))
end
function c511001109.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511001109.filter,tp,0,LOCATION_MZONE,nil)
	return g:GetCount()>0 and Duel.GetCurrentChain()==0 and not e:GetHandler():IsStatus(STATUS_CHAINING) 
		and Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c511001109.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511001109.filter,tp,0,LOCATION_MZONE,nil)
	local sc=g:Select(tp,1,1,nil):GetFirst()
	if not sc then return end
	sc:ResetFlagEffect(511001109)
	local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,sc)
	if Duel.GetAttacker() then
		Duel.ChangeAttacker(sc)
		if dg:GetCount()==0 then
			Duel.ChangeAttackTarget(nil)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EXTRA_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			e2:SetValue(Duel.GetAttacker():GetEffectCount(EFFECT_EXTRA_ATTACK)+1)
			Duel.GetAttacker():RegisterEffect(e2)
		else
			local dc=dg:Select(tp,1,1,nil):GetFirst()
			Duel.ChangeAttackTarget(dc)
		end
	else
		if dg:GetCount()==0 then
			Duel.Damage(1-tp,sc:GetAttack(),REASON_BATTLE)
		else
			local dc=dg:Select(tp,1,1,nil):GetFirst()
			Duel.CalculateDamage(sc,dc)
		end
	end
end
