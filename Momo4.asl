
// Futureproofing info
// This game seems to be updated frequently, so we need to set up some aobscans ASAP

// TODO
// Flags' addresses are accessed by adding a base address to an offset in eax (I think it's eax anyways). The flags are all doubles.
// * edeaDefeated: 0xE0
// * arsonistDefeated: 0x9E0
// * warpStone: 0x5C0
// * monasteryKey: 0x260
// * fennelDefeated: 0x3D0
// * magnoliaDefeated: 0x660
// * cloneAngelDefeated: 0x640
// * choirDefeated: 0x6A0
// * ivoryBugs: 0x3C0
// * vitalityFragments: 0xAE0
// * enemiesKilled: 0x490

// NOTE: Note that the queen doesn't have a flag. This makes sense since the game immediately ends after she is defeated.
// Some flags are unpractical to use, and so there is likely a better way to check if bosses are defeated if we can point to HP and use levelId, which transitions to the next point.

// TODO: Find a solid health pointer -- if Edea bleeds before she's active, then there is a pointer, even if we have trouble finding it.
// *Do not use 0, 0, 4, 230*
// We might be able to make our own pointer using an aobscan for code that changes boss HP
// Bosses die at <= 11 HP

// DONE!
// levelId is 1 at title, 11 in save, 21 in first room -- it is a byte
//

// TODO
// difficultySelector needs to be used for best start timing, it's 1 when looking at easy, 2 for normal, 3 for hard, 4 for insane, and 0 otherwise.

// TODO
// even if a universal HP can't be found, since it's found off of charHP we can still use cutsceneProgress
// cutsceneProgress is a misnomer, I'm not sure how this changes but it is consistent and stable.

// TODO
// find aobscan for characterHP being changed
// offsets from characterHP address:
// * characterHP: 0x0
// * inGame: 0x780
// * cutsceneProgress: 0xAB0


state("MomodoraRUtM", "v1.04d")
{

	// General
/*	double cutseneProgress : 0x2300A48, 0x4, 0xAB0;*/
	/*string6 versionId : 0x8E9899;*/

	// depreciated
	/*byte levelId : "MomodoraRUtM.exe", 0x230AF00;*/

	// For start
 	double difficultySelector : 0x22C17DC, 0xCB4, 0xC, 0x4, 0x41B0;

 	// For reset
/* 	double inGame : 0x2300A48, 0x4, 0x780;*/
/* 	double characterHP : 0x2300A48, 0x4, 0x0;*/

 	// Edea split
 	double edeaDefeated : 0x2300A48, 0x4, 0x60, 0x4, 0x4, 0xE0;

 	// Lubella 1 split
 	double lubella1HP : 0x230D0EC, 0x8, 0x140, 0x4, 0x230;
 	double lubella1HPMax : 0x230D0EC, 0x8, 0x140, 0x4, 0x240;

 	// Frida split
 	// see cutsceneProgress

 	// Arsonist split
 	double arsonistDefeated : 0x2300A48, 0x4, 0x60, 0x4, 0x4, 0x9E0;

 	// Warpstone
 	double warpStone : 0x2300A48, 0x4, 0x60, 0x4, 0x4, 0x5C0;

 	// Monastery Key
 	double monasteryKey : 0x2300A48, 0x4, 0x60, 0x4, 0x4, 0x260;

 	// Fennel
 	double fennelDefeated : 0x2300A48, 0x4, 0x60, 0x4, 0x4, 0x3D0;

  	// Lupiar and Magnolia
 	double magnoliaDefeated : 0x2300A48, 0x4, 0x60, 0x4, 0x4, 0x660;

 	// Fresh Spring Leaf
 	double freshSpringLeaf : 0x2300A48, 0x4, 0x60, 0x4, 0x4, 0x600;

 	// Clone Angel
 	double cloneAngelDefeated : 0x2300A48, 0x4, 0x60, 0x4, 0x4, 0x640;

 	// Queen
 	// see cutsceneProgress

 	// Choir
 	double choirDefeated : 0x2300A48, 0x4, 0x60, 0x4, 0x4, 0x6A0;

 	// 100%
 	double ivoryBugs : 0x2300A48, 0x4, 0x60, 0x4, 0x4, 0x3C0;
 	double vitalityFragments : 0x2300A48, 0x4, 0x60, 0x4, 0x4, 0xAE0;

 	// Statistics
 	double enemiesKilled : 0x2300A48, 0x4, 0x60, 0x4, 0x4, 0x490;
}

startup
{
	// SETTINGS START //
	settings.Add("saveRunData", false, "Save Run Data");
	settings.Add("100%Check", false, "100% Run");
	settings.Add("splits", true, "All Splits");

	settings.Add("edea", true, "Edea", "splits");
	settings.Add("lubella1", true, "Lubella 1", "splits");
	settings.Add("frida", true, "Frida", "splits");
	settings.Add("lubella2", true, "Lubella 2", "splits");
	settings.Add("warpFragment", true, "Warp Fragment", "splits");
	settings.Add("arsonist", true, "Arsonist", "splits");
	settings.Add("monasteryKey", true, "Monastery Key", "splits");
	settings.Add("fennel", true, "Fennel", "splits");
	settings.Add("magnolia", true, "Lupiar and Magnolia", "splits");
	settings.Add("freshSpringLeaf", true, "Fresh Spring Leaf", "splits");
	settings.Add("cloneAngel", true, "Clone Angel", "splits");
	settings.Add("queen", true, "Queen", "splits");
	settings.Add("choir", false, "Choir", "splits");

	settings.SetToolTip("saveRunData", "REQUIRES LIVESPLIT TO BE RUN AS ADMINISTRATOR. Will create a text file containing run stats under \"Livesplit 1.6.9\\MomodoraRUtM\"");
	settings.SetToolTip("100%Check", "If checked, will only split for Queen if Choir is defeated, 17 vitality fragments were obtained, and 20 bug ivories were collected.");

	print("Hey, this compiled correctly. Way to go!");
	// SETTINGS END //

	// AOB SCANS //

	vars.watchers = new MemoryWatcherList();

}

init
{

	// Statistics
	vars.hpLost = 0;

	// AOB SCANS //

	var module = modules.First();
	var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);

	vars.levelIdCodeTarget = new SigScanTarget(2,
		"89 35 ?? ?? ?? ??", 	// mov [035AAF00],esi ; destination is levelId address, other code that follows is only for the purposes of finding a unique match
		"7D 0B",				// jnl 018CAB1A
		"8B 15 ?? ?? ?? ??",	// mov edx,[035AAF64]
		"8B 04 B2",				// mov eax,[edx+esi*4]
		"EB 02",				// jmp 018CAB1C
		"33 C0",				// xor eax,eax
		"50",					// push eax
		"E8 ?? ?? ?? ??"		// call 018C94F0
	);

	vars.flagsBaseAddrCodeTarget = new SigScanTarget(1,
		"A1 ?? ?? ?? ??",			// mov eax,[02400A48] (MomodoraRUtM.exe+2300A48) ; base address we're looking for for flags/character/gamestatus pointer
		"8B 40 04",					// mov eax,[eax+04]
		"C7 44 24 10 ?? ?? ?? ??",	// mov [esp+10],00000000
		"F2 ?? ?? 88 ?? ?? ?? ??",	// cvttsd2si ecx,[eax+00000660] ; what is this opcode even
		"85 C9",					// test ecx,ecx
		"7F 0C"						// jg 0013C1D2
	);


	// Wait for the game to be loaded, otherwise scans will return 0
	Thread.Sleep(2000);

	// Find code address (+ 0x2 for levelId, first int in SigScanTarget)
	vars.levelIdCodeAddr = scanner.Scan(vars.levelIdCodeTarget);
	vars.flagsBaseAddrCodeAddr = scanner.Scan(vars.flagsBaseAddrCodeTarget);

	// Read the address for levelID from code
	vars.levelIdAddr = memory.ReadValue<int>((IntPtr)vars.levelIdCodeAddr);
	vars.flagsBaseAddr = memory.ReadValue<int>((IntPtr)vars.flagsBaseAddrCodeAddr);

	// offsets 0x4, 0x0 for character HP
	// 0x4, 0x780 for inGame
	// 0x4, 0xAB0 for cutsceneProgress
	vars.hpPointerLevel1 = memory.ReadValue<int>((IntPtr)vars.flagsBaseAddr) + 0x4;

	vars.characterHPAddr = memory.ReadValue<int>((IntPtr)vars.hpPointerLevel1) + 0x0;
	vars.inGameAddr = memory.ReadValue<int>((IntPtr)vars.hpPointerLevel1) + 0x780;
	vars.cutsceneProgressAddr = memory.ReadValue<int>((IntPtr)vars.hpPointerLevel1) + 0xAB0;

	// Offset 0x4 (from hpPointerLevel1), 0x60, 0x4, 0x4, 0xXXX
	// * edeaDefeated: 0xE0
	// * arsonistDefeated: 0x9E0
	// * warpStone: 0x5C0
	// * monasteryKey: 0x260
	// * fennelDefeated: 0x3D0
	// * magnoliaDefeated: 0x660
	// * freshSpringLeaf: 0x600
	// * cloneAngelDefeated: 0x640
	// * choirDefeated: 0x6A0
	// * ivoryBugs: 0x3C0
	// * vitalityFragments: 0xAE0
	// * enemiesKilled: 0x490
	vars.flagsPointerLevel2 = memory.ReadValue<int>((IntPtr)vars.hpPointerLevel1) + 0x60;
	vars.flagsPointerLevel3 = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel2) + 0x4;
	vars.flagsPointerLevel4 = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel3) + 0x4;

	vars.edeaDefeatedAddr = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel4) + 0xE0;
	vars.arsonistDefeatedAddr = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel4) + 0x9E0;
	vars.warpStoneAddr = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel4) + 0x5C0;
	vars.monasteryKeyAddr = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel4) + 0x260;
	vars.fennelDefeatedAddr = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel4) + 0x3D0;
	vars.magnoliaDefeatedAddr = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel4) + 0x660;
	vars.freshSpringLeafAddr = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel4) + 0x660;
	vars.cloneAngelDefeatedAddr = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel4) + 0x640;
	vars.choirDefeatedAddr = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel4) + 0x6A0;
	vars.ivoryBugsAddr = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel4) + 0x3C0;
	vars.vitalityFragmentsAddr = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel4) + 0xAE0;
	vars.enemiesKilledAddr = memory.ReadValue<int>((IntPtr)vars.flagsPointerLevel4) + 0x490;



	// Read the value of that address
	vars.levelId = new MemoryWatcher<byte>((IntPtr)vars.levelIdAddr);
	vars.characterHP = new MemoryWatcher<double>((IntPtr)vars.characterHPAddr);
	vars.inGame = new MemoryWatcher<double>((IntPtr)vars.inGameAddr);
	vars.cutsceneProgress = new MemoryWatcher<double>((IntPtr)vars.cutsceneProgressAddr);

	vars.edeaDefeated = new MemoryWatcher<double>((IntPtr)vars.edeaDefeatedAddr);
	vars.arsonistDefeated = new MemoryWatcher<double>((IntPtr)vars.arsonistDefeatedAddr);
	vars.warpStone = new MemoryWatcher<double>((IntPtr)vars.warpStoneAddr);
	vars.monasteryKey = new MemoryWatcher<double>((IntPtr)vars.monasteryKeyAddr);
	vars.fennelDefeated = new MemoryWatcher<double>((IntPtr)vars.fennelDefeatedAddr);
	vars.magnoliaDefeated = new MemoryWatcher<double>((IntPtr)vars.magnoliaDefeatedAddr);
	vars.freshSpringLeaf = new MemoryWatcher<double>((IntPtr)vars.freshSpringLeafAddr);
	vars.cloneAngelDefeated = new MemoryWatcher<double>((IntPtr)vars.cloneAngelDefeatedAddr);
	vars.choirDefeated = new MemoryWatcher<double>((IntPtr)vars.choirDefeatedAddr);
	vars.ivoryBugs = new MemoryWatcher<double>((IntPtr)vars.ivoryBugsAddr);
	vars.vitalityFragments = new MemoryWatcher<double>((IntPtr)vars.vitalityFragmentsAddr);
	vars.enemiesKilled = new MemoryWatcher<double>((IntPtr)vars.enemiesKilledAddr);

	vars.watchers.Clear();
	vars.watchers.AddRange(new MemoryWatcher[]
	{
		vars.levelId,
		vars.characterHP,
		vars.inGame,
		vars.cutsceneProgress,
		vars.edeaDefeated,
		vars.arsonistDefeated,
		vars.warpStone,
		vars.monasteryKey,
		vars.fennelDefeated,
		vars.magnoliaDefeated,
		vars.cloneAngelDefeated,
		vars.choirDefeated,
		vars.ivoryBugs,
		vars.vitalityFragments,
		vars.enemiesKilled
	});








}

update
{
	// Save run data. REQUIRES ADMIN RIGHTS!
	if (settings["saveRunData"] && vars.levelId.Current == 232 && vars.cutsceneProgress.Old != 1000 && vars.cutsceneProgress.Current == 1000) {
		if (!System.IO.Directory.Exists("MomodoraRUtM")) {
			System.IO.Directory.CreateDirectory("MomodoraRUtM");
		}
		using (System.IO.StreamWriter sw = new System.IO.StreamWriter(@"MomodoraRUtM\MomodoraRUtM " + DateTime.Now.ToString("HH.mm.ss - MM.dd.yyyy") + ".txt")) {
			if (current.choirDefeated == 1 && current.ivoryBugs == 20 && current.vitalityFragments == 17) {
				sw.WriteLine("Is this a \"100%\" run?: True");
			}
			else {
				sw.WriteLine("Is this a \"100%\" run?: False");
			}
			sw.WriteLine("Has Choir been defeated?: " + Convert.ToBoolean(current.choirDefeated));
			sw.WriteLine("Bug ivories collected: " + current.ivoryBugs + "/20.");
			sw.WriteLine("Vitality fragments collected: " + current.vitalityFragments + "/17.");
			sw.WriteLine("\r\n_______________\r\n");
			sw.WriteLine("Total HP lost: " + vars.hpLost);
			sw.WriteLine("Non-boss enemies killed: " + current.enemiesKilled);
		}
	}

	// Statistics management start
	if (timer.CurrentTime.ToString() == "00:00:00 | 00:00:00") {
		// Reset variables
		vars.hpLost = 0;
	}

	if (vars.characterHP.Current < vars.characterHP.Old && vars.inGame.Current == 1) {
		vars.hpLost += (vars.characterHP.Old - vars.characterHP.Current);
	}

	vars.watchers.UpdateAll(game);

	// DEBUG
	/*print(vars.characterHP.Current.ToString());*/
}

start
{
	// If we were in the difficulty menu and then left it
	// this value is preserved if we return to title menu
	if (old.difficultySelector > 0 && current.difficultySelector == 0) {
		print("start returned true!");
		return true;
	}
}

reset
{
	// inGame could be set to 0 when respawning after a death
	// to prevent this tripping we check that characterHP is 30
	// under normal circumstances, when dead characterHP is 0
	// characterHP is set to 30 when returning to the title menu
	// if this *still* causes trouble we should rewrite it to check levelId
	if (vars.inGame.Current == 0 && vars.inGame.Old == 1 && vars.characterHP.Current == 30) {
		print("reset returned true!");
		return true;
	}
}

split
{


	// various flags are set during or at the beginning of boss fights, which is why we use cutsceneProgress trickery.
	// vars.inGame.Old is to prevent splits upon loading a save.

	// Edea
	if (settings["edea"] && vars.edeaDefeated.Old == 0 && vars.edeaDefeated.Current == 1 && vars.inGame.Old == 1) {
		print("Edea defeated!");
		return true;
	}
	// Lubella 1
	if (settings["lubella1"] && old.lubella1HP > 11 && current.lubella1HPMax == 130 && current.lubella1HP <= 11) {
		print("Lubella 1 defeated!");
		vars.lubella1Defeated = true;
		return true;
	}
	// Frida
	if (settings["frida"] && vars.levelId.Current == 141 && vars.cutsceneProgress.Current == 0 && vars.cutsceneProgress.Old == 500) {
		print("Frida defeated!");
		return true;
	}
	// Lubella 2
	if (settings["lubella2"] && vars.cutsceneProgress.Current == 0 && vars.cutsceneProgress.Old == 500 && vars.levelId.Current == 147) {
		print("Lubella 2 defeated!");
		return true;
	}
	// Arsonist
	if (settings["arsonist"] && vars.arsonistDefeated.Old == 0 && vars.arsonistDefeated.Current == 1 && vars.inGame.Old == 1) {
		print("Arsonist defeated!");
		return true;
	}
	// Fennel - SPLITS AT END OF CUTSCENE, WILL PROBABLY CHANGE LOGIC LATER
	if (settings["fennel"] && vars.fennelDefeated.Old == 0 && vars.fennelDefeated.Current == 1 && vars.inGame.Old == 1) {
		print("Fennel defeated!");
		return true;
	}
	// Lupiar & Magnolia - Splits when talking to Magnolia
	if (settings["magnolia"] && vars.magnoliaDefeated.Old == 0 && vars.magnoliaDefeated.Current == 1 && vars.inGame.Old == 1) {
		print("Magnolia defeated!");
		return true;
	}
	// Clone Angel
	if (settings["cloneAngel"] && vars.cloneAngelDefeated.Old == 0 && vars.cloneAngelDefeated.Current == 1 && vars.inGame.Old == 1) {
		print("Clone Angel defeated!");
		return true;
	}
	// Queen
	if (settings["queen"] && !settings["100%Check"] && vars.levelId.Current == 232 && vars.cutsceneProgress.Old != 1000 && vars.cutsceneProgress.Current == 1000) {
		print("Queen defeated!");
		return true;
	}

	// Queen 100%
	if (settings["queen"] && settings["100%Check"] && vars.levelId.Current == 232 && vars.cutsceneProgress.Old != 1000 && vars.cutsceneProgress.Current == 1000) {
		print("Checking 100% conditions:");
		print("Has Choir been defeated?: " + Convert.ToBoolean(current.choirDefeated));
		print("Bug ivories collected: " + current.ivoryBugs + "/20.");
		print("Vitality fragments collected: " + current.vitalityFragments + "/17.");
		if (current.choirDefeated == 1 && current.ivoryBugs == 20 && current.vitalityFragments == 17) {
			return true;
		}
	}

	// Choir
	if (settings["choir"] && vars.choirDefeated.Old == 0 && vars.choirDefeated.Current == 1 && vars.inGame.Old == 1) {
		vars.choirDefeated = 1;
		print("Choir defeated!");
		return true;
	}

	// Warpstone
	if (settings["warpFragment"] && vars.warpStone.Old == 0 && vars.warpStone.Current == 1 && vars.inGame.Old == 1) {
		print("Warp fragment obtained!");
		return true;
	}
	// Monastery key
	if (settings["monasteryKey"] && vars.monasteryKey.Old == 0 && vars.monasteryKey.Current == 1 && vars.inGame.Old == 1) {
		print("Monastery key obtained!");
		return true;
	}
	// Fresh Spring Leaf
	if (settings["freshSpringLeaf"] && vars.freshSpringLeaf.Old == 0 && vars.freshSpringLeaf.Current == 1 && vars.inGame.Old == 1) {
		print("Fresh Spring Leaf obtained!");
		return true;
	}
}

exit
{
	vars.watchers.Clear();
}