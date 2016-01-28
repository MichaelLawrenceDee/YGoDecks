--The Seal of Orichalcos
function c511000256.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000256.acttg)
	e1:SetOperation(c511000256.actop)
	c:RegisterEffect(e1)
	--ATK Up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Cannot be destroyed or negated by card effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c511000256.indval)
	c:RegisterEffect(e3)
	--Cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c511000256.cannotatkcon)
	e4:SetTarget(c511000256.cannotatktg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Cannot Activate "Orichalcos Deuteros" in the Same Turn
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(1,1)
	e5:SetValue(c511000256.aclimit)
	e5:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e5)
end
function c511000256.desfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)~=0 and c:IsDestructable() and c:IsCode(170000150) or c:IsCode(170000154) or c:IsCode(170000155) or c:IsCode(170000157) or c:IsCode(170000158)
	or c:IsCode(170000193) or c:IsCode(170000194) or c:IsCode(170000196) or c:IsCode(170000197)
end
function c511000256.mgfilter(c,e,tp,fusc)
	return bit.band(c:GetReason(),0x40008)==0x40008
end
function c511000256.mgfilter2(c,e,tp,fusc)
	return bit.band(c:GetReason(),0x40008)==0x40008 and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c511000256.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c511000256.desfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
	end
function c511000256.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c511000256.desfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	local g2=Duel.GetMatchingGroup(c511000256.mgfilter,tp,LOCATION_GRAVE,0,nil)
	local g3=Duel.GetMatchingGroup(c511000256.mgfilter2,tp,LOCATION_GRAVE,0,nil)
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		Duel.SSet(tp,g3:GetFirst())
		Duel.ConfirmCards(1-tp,g3)
	end
end
function c511000256.indval(e,re)
	return not re:GetHandler():IsCode(170000201)
end
function c511000256.cannotatkcon(e)
	return Duel.IsExistingMatchingCard(Card.IsPosition,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil,POS_FACEUP)
end
function c511000256.cannotatkfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end
function c511000256.cannotatktg(e,c)
	return not Duel.IsExistingMatchingCard(c511000256.cannotatkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,c,c:GetAttack())
end
function c511000256.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return not rc:IsCode(110000100) and rc:IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
