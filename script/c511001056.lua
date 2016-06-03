--おろかな埋葬
function c511001056.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001056.target)
	e1:SetOperation(c511001056.activate)
	c:RegisterEffect(e1)
end
function c511001056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c511001056.filter(c,tp)
	return c:GetOwner()==tp
end
function c511001056.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
		local g3=Duel.GetMatchingGroup(c511001056.filter,tp,0,LOCATION_GRAVE,nil,tp)
		if g3:GetCount()>0 then
			Duel.SwapDeckAndGrave(1-tp)
			Duel.SwapDeckAndGrave(1-tp)
		end
		g:Merge(g3)
		Duel.SendtoDeck(g,1-tp,0,REASON_RULE)
		Duel.SwapDeckAndGrave(1-tp)
		Duel.SendtoDeck(g1,1-tp,0,REASON_RULE)
		Duel.SendtoGrave(g2,REASON_RULE+REASON_RETURN)
		Duel.SendtoGrave(g2,REASON_RULE+REASON_RETURN)
	end
end
