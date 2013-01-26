//
//  Names.m
//  TokenFieldExample
//
//  Created by Tom on 06/03/2010.
//  Copyright 2010 Tom Irving. All rights reserved.
//

#import "Names.h"
#import "TIContact.h"

@implementation Names

+ (NSArray *)listOfNames {
	
	// Generated with http://www.kleimo.com/random/name.cfm
	
	return @[
	[TIContact contactWithName:@"Samuel Prescott" email:@"SamuelPrescott@PrescottTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Grace Mcburney" email:@"GraceMcburney@McburneyTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Rosemary Sells" email:@"RosemarySells@SellsTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Janet Canady" email:@"JanetCanady@CanadyTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Gregory Leech" email:@"GregoryLeech@LeechTestMail.com" label:@"others"],
	[TIContact contactWithName:@"Geneva Mcguinness" email:@"GenevaMcguinness@McguinnessTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Billy Shin" email:@"BillyShin@ShinTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Douglass Fostlick" email:@"DouglassFostlick@FostlickTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Roberta Pedersen" email:@"RobertaPedersen@PedersenTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Earl Rashid" email:@"EarlRashid@RashidTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Matthew Hooks" email:@"MatthewHooks@HooksTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Regina Toombs" email:@"ReginaToombs@ToombsTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Victor Sisneros" email:@"VictorSisneros@SisnerosTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Beverly Covington" email:@"BeverlyCovington@CovingtonTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Steve Crews" email:@"SteveCrews@CrewsTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Carlos Trejo" email:@"CarlosTrejo@TrejoTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Victoria Delgadillo" email:@"VictoriaDelgadillo@DelgadilloTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Leah Greenberg" email:@"LeahGreenberg@GreenbergTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Deborah Depew" email:@"DeborahDepew@DepewTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Jeffery Khoury" email:@"JefferyKhoury@KhouryTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Kathryn Worsham" email:@"KathrynWorsham@WorshamTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Olivia Brownell" email:@"OliviaBrownell@BrownellTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Gary Pritchard" email:@"GaryPritchard@PritchardTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Susan Cervantes" email:@"SusanCervantes@CervantesTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Olvera Nipplehead" email:@"OlveraNipplehead@NippleheadTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Debra Graves" email:@"DebraGraves@GravesTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Albert Deltoro" email:@"AlbertDeltoro@DeltoroTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Carole Flatt" email:@"CaroleFlatt@FlattTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Philip Vo" email:@"PhilipVo@VoTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Phillip Wagstaff" email:@"PhillipWagstaff@WagstaffTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Xiao Jacquay" email:@"XiaoJacquay@JacquayTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Cleotilde Vondrak" email:@"CleotildeVondrak@VondrakTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Carter Redepenning" email:@"CarterRedepenning@RedepenningTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Kaycee Wintersmith" email:@"KayceeWintersmith@WintersmithTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Collin Tick" email:@"CollinTick@TickTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Peg Yore" email:@"PegYore@YoreTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Cruz Buziak" email:@"CruzBuziak@BuziakTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Ardath Osle" email:@"ArdathOsle@OsleTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Frederic Manusyants" email:@"FredericManusyants@ManusyantsTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Collin Politowski" email:@"CollinPolitowski@PolitowskiTestMail.com" label:@"work"],
	[TIContact contactWithName:@"Hunter Wollyung" email:@"HunterWollyung@WollyungTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Cruz Gurke" email:@"CruzGurke@GurkeTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Sulema Sholette" email:@"SulemaSholette@SholetteTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Denver Goetter" email:@"DenverGoetter@GoetterTestMail.com" label:@"other"],
	[TIContact contactWithName:@"Chantay Phothirath" email:@"ChantayPhothirath@PhothirathTestMail.com" label:@"other"],
	[TIContact contactWithName:@"Arlean Must" email:@"ArleanMust@MustTestMail.com" label:@"other"],
	[TIContact contactWithName:@"Carlo Henggeler" email:@"CarloHenggeler@HenggelerTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Daughrity Maichle" email:@"DaughrityMaichle@MaichleTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Zada Wintermantel" email:@"ZadaWintermantel@WintermantelTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Denver Kubu" email:@"DenverKubu@KubuTestMail.com" label:@"other"],
	[TIContact contactWithName:@"Carlo Guzma" email:@"CarloGuzma@GuzmaTestMail.com" label:@"other"],
	[TIContact contactWithName:@"Emory Swires" email:@"EmorySwires@SwiresTestMail.com" label:@"other"],
	[TIContact contactWithName:@"Kirby Manas" email:@"KirbyManas@ManasTestMail.com" label:@"other"],
	[TIContact contactWithName:@"Tobie Spirito" email:@"TobieSpirito@SpiritoTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Lane Defaber" email:@"LaneDefaber@DefaberTestMail.com" label:@"other"],
	[TIContact contactWithName:@"Sparkle Mousa" email:@"SparkleMousa@MousaTestMail.com" label:@"other"],
	[TIContact contactWithName:@"Chantay Palczynski" email:@"ChantayPalczynski@PalczynskiTestMail.com" label:@"home"],
	[TIContact contactWithName:@"Denver Perfater" email:@"DenverPerfater@PerfaterTestMail.com" label:@"other"],
	[TIContact contactWithName:@"Tom Irving" email:@"TomIrving@IrvingTestMail.com" label:@"home"]];
}

@end