--Oily Cicada
function c511002163.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCondition(c511002163.con)
	e1:SetCode(511001225)
	c:RegisterEffect(e1)
	--register
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetOperation(c511002163.regop)
	c:RegisterEffect(e2)
	if not c511002163.global_check then
		c511002163.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511002163.xyzchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511002163.xyzchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,419)
	Duel.CreateToken(1-tp,419)
end
function c511002163.con(e)
	return e:GetHandler():GetFlagEffect(511002163)>0
end
function c511002163.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(511002163,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
