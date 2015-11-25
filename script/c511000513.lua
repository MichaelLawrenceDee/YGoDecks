--Number 77: The Seven Sins
function c511000513.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000513,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c511000513.cost)
	e1:SetTarget(c511000513.target)
	e1:SetOperation(c511000513.operation)
	c:RegisterEffect(e1)
	--banish replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(c511000513.reptg)
	c:RegisterEffect(e2)
end
c511000513.xyz_number=77
function c511000513.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511000513.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511000513.filter(c,s)
	return not c:IsLocation(LOCATION_MZONE) and c~=s
end
function c511000513.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT) then
		g=g:Filter(c511000513.filter,nil,e:GetHandler())
		if e:GetHandler():IsLocation(LOCATION_MZONE) then
			Duel.Overlay(e:GetHandler(),g)
		end
	end
end
function c511000513.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_REMOVED and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	if Duel.SelectYesNo(tp,aux.Stringid(77631175,0)) then
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
		return true
	else return false end
end
