--Vampiric Leech
function c511000173.initial_effect(c)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511000173.con)
	e1:SetOperation(c511000173.op)
	c:RegisterEffect(e1)
	--reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetOperation(c511000173.regop)
	c:RegisterEffect(e2)
	--change battle position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511000173,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c511000173.poscon)
	e3:SetCost(c511000173.poscost)
	e3:SetOperation(c511000173.posop)
	c:RegisterEffect(e3)
end
function c511000173.con(e,c,og)
	if c==nil then return true end
	local ct=c:GetEffectCount(EFFECT_EXTRA_ATTACK)
	return Duel.GetTurnCount()==1 and c:GetFlagEffect(511000173)<=ct
end
function c511000173.op(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0 then
		Duel.Damage(1-tp,c:GetAttack(),REASON_BATTLE)
		Duel.RaiseEvent(c,EVENT_BATTLE_DAMAGE,e,REASON_BATTLE,1-tp,tp,c:GetAttack())
		Duel.RaiseEvent(c,EVENT_DAMAGE,e,REASON_BATTLE,1-tp,tp,c:GetAttack())
		c:RegisterFlagEffect(511000174,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else
		local tg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		Duel.CalculateDamage(c,tg)
	end
	c:RegisterFlagEffect(511000173,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c511000173.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetAttackTarget() then return end
	c:RegisterFlagEffect(511000174,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c511000173.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c511000173.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(511000174)>0
end
function c511000173.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetOperation(c511000173.desop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		c:RegisterEffect(e1)
	end
end
function c511000173.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsAttackPos() then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENCE,POS_FACEDOWN_DEFENCE,0,0)
	end
end
