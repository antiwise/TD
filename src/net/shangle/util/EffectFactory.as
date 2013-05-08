package net.shangle.util
{
	import net.shangle.display.BurningEffect;
	import net.shangle.display.ColdConeEffect;
	import net.shangle.display.Effect;
	import net.shangle.display.FatalBlowEffect;
	import net.shangle.display.HealEffect;
	import net.shangle.display.LightningEffect;
	import net.shangle.display.MetorEffect;
	import net.shangle.vo.EffectVO;

	public class EffectFactory
	{
		public function EffectFactory()
		{
		}
		
		private static const HEAL_EFFECT:int=1;
		private static const LIGHTNING_EFFECT:int=2;
		private static const METOR_EFFECT:int=3;
		
		
		private static const BURNING_EFFECT:int=4;
		private static const COLD_CONE_EFFECT:int=5;
		private static const FATAL_BLOW_EFFECT:int=6;
		
		
		public static function getEffect(vo:EffectVO,instanceID:int):Effect
		{
			switch(vo.type)
			{
				case METOR_EFFECT:
				{
					return new MetorEffect(vo,instanceID);
				}
				case LIGHTNING_EFFECT:
				{
					return new LightningEffect(vo,instanceID);
				}
				case HEAL_EFFECT:
				{
					return new HealEffect(vo,instanceID);
				}
				case COLD_CONE_EFFECT:
				{
					return new ColdConeEffect(vo,instanceID);
				}
				case BURNING_EFFECT:
				{
					return new BurningEffect(vo,instanceID);
				}
				case FATAL_BLOW_EFFECT:
				{
					return new FatalBlowEffect(vo,instanceID);
				}
			}
			return null;
		}
	}
}