<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<UiMod name="BagBonus" version="1.0.0" date="07/04/2025" >
		<Author name="Psychoxell (Adeptha)" email="" />
		<Description text="Show the bag bonus in a new character window tab" />
		<VersionSettings gameVersion="1.4.8" windowsVersion="1.0"/>
		<WARInfo>
			<Categories>
				<Category name="OTHER" />
			</Categories>
			<Careers>
				<Career name="BLACKGUARD" />
				<Career name="WITCH_ELF" />
				<Career name="DISCIPLE" />
				<Career name="SORCERER" />
				<Career name="IRON_BREAKER" />
				<Career name="SLAYER" />
				<Career name="RUNE_PRIEST" />
				<Career name="ENGINEER" />
				<Career name="BLACK_ORC" />
				<Career name="CHOPPA" />
				<Career name="SHAMAN" />
				<Career name="SQUIG_HERDER" />
				<Career name="WITCH_HUNTER" />
				<Career name="KNIGHT" />
				<Career name="BRIGHT_WIZARD" />
				<Career name="WARRIOR_PRIEST" />
				<Career name="CHOSEN" />
				<Career name="MARAUDER" />
				<Career name="ZEALOT" />
				<Career name="MAGUS" />
				<Career name="SWORDMASTER" />
				<Career name="SHADOW_WARRIOR" />
				<Career name="WHITE_LION" />
				<Career name="ARCHMAGE" />
			</Careers>
		</WARInfo>
		<Dependencies/>
		<Files>
			<File name="BagBonus.xml"/>
			<File name="BagBonus.lua"/>
		</Files>
		<OnInitialize>
			<CallFunction name="BagBonus.Initialize" />      
		</OnInitialize>
		<OnUpdate>
			<CallFunction name="BagBonus.OnUpdate" />
		</OnUpdate>
		<OnShutdown>
			<CallFunction name="BagBonus.Shutdown" /> 
		</OnShutdown>
	</UiMod>
</ModuleFile>