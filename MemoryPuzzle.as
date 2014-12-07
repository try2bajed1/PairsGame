package {

import com.greensock.TweenLite;

import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.Sound;
import flash.text.AutoCapitalize;
import flash.text.TextField;
import flash.utils.setInterval;
[Frame(factoryClass="Preloader")]

[SWF(width="1000", height="750", frameRate="24", backgroundColor="#000000")]

public class MemoryPuzzle extends Sprite {


/*
    public static var TYPE_PHONE_1:uint = 1;
    public static var TYPE_PHONE_2:uint = 2;
    public static var TYPE_PHONE_3:uint = 3;
    public static var TYPE_PHONE_4:uint = 4;
    public static var TYPE_PHONE_5:uint = 5;
    public static var TYPE_PHONE_6:uint = 6;
    public static var TYPE_PHONE_7:uint = 7;
    public static var TYPE_PHONE_8:uint = 8;
    public static var TYPE_PHONE_9:uint = 9;*/



    private var introMC:Intro;
    private var rulesMC:Rules;
    private var gameMC:MovieClip;
    private var clickSnd:ClickSnd = new ClickSnd();


    public function MemoryPuzzle() {


        if (stage) init();
        else addEventListener(Event.ADDED_TO_STAGE, init);
    }


    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        initInterface();
    }




    private function initInterface():void {

        var bcg:Shape = new Shape();
        bcg.graphics.beginBitmapFill(new BCG_Pattern(), null, true, false);
        bcg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
        bcg.graphics.endFill();
        addChild(bcg);


        introMC = new Intro();
        introMC.rules_btn.addEventListener(MouseEvent.CLICK, openRules);
        introMC.play_btn.addEventListener(MouseEvent.CLICK, startGamefromIntro);
        addChild(introMC);

        rulesMC = new Rules();
        rulesMC.play_btn.addEventListener(MouseEvent.CLICK, startGamefromRules);
        rulesMC.visible = false;
        addChild(rulesMC);

        gameMC = new Game() ;
        gameMC.visible = false;
        addChild(gameMC);

    }




    private function openRules(e:MouseEvent):void {

        clickSnd.play();
        TweenLite.to(introMC, 0.5, {alpha: 0, visible: false,onComplete:showRules});
    }


    private function showRules():void {
        rulesMC.visible = true;
    }




    private function startGamefromIntro(e:MouseEvent):void {
        clickSnd.play();
        TweenLite.to(introMC, 0.5, {alpha: 0, visible: false, onComplete:showGame});
    }



    private function startGamefromRules(e:MouseEvent):void {
        clickSnd.play();
        TweenLite.to(rulesMC, 0.5, {alpha: 0, visible: false, onComplete:showGame});

    }





    private function showGame():void {
        gameMC.visible = true;
        Game(gameMC).refreshGame();
    }


}
}
