/**
 * Created with IntelliJ IDEA.
 * User: n.senchurin
 * Date: 04.04.2014
 * Time: 14:07
 */
package {
import com.greensock.TweenLite;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.text.TextField;

public class Card extends MovieClip{

    private var _type:uint;
    private var questionBM:Bitmap;
    private var _phonePictureBM:Bitmap;

    private var _bcgBM:Bitmap;


    public static var TYPE_PHONE_1:uint = 1;
    public static var TYPE_PHONE_2:uint = 2;
    public static var TYPE_PHONE_3:uint = 3;
    public static var TYPE_PHONE_4:uint = 4;
    public static var TYPE_PHONE_5:uint = 5;
    public static var TYPE_PHONE_6:uint = 6;
    public static var TYPE_PHONE_7:uint = 7;
    public static var TYPE_PHONE_8:uint = 8;
    public static var TYPE_PHONE_9:uint = 9;

    /**
        все типы карточек содержатся в этом массиве.
     При инициализации игры создается новый массив в 2 раза длиннее, путем сложения с самим собой (т.о. получаются пары).
     Затем этот удвоенный массив перемешивается и относительно перемешанного выкладываются карточки
     */
    public static var typesEnumVec:Vector.<uint> = Vector.<uint>([TYPE_PHONE_1, TYPE_PHONE_2, TYPE_PHONE_3, TYPE_PHONE_4, TYPE_PHONE_5,TYPE_PHONE_6, TYPE_PHONE_7, TYPE_PHONE_8, TYPE_PHONE_9 ]);


    public function Card(cardType:uint) {

        this._type = cardType;

        var bcgBD:BitmapData = new CardBcg();
        _bcgBM = new Bitmap(bcgBD);
        addChild(_bcgBM);

        _phonePictureBM = new Bitmap();
        _phonePictureBM.bitmapData = getCardBitmapByType(cardType)
        _phonePictureBM.x = Math.floor((_bcgBM.width - _phonePictureBM.width)/2);
        _phonePictureBM.y = Math.floor((_bcgBM.height - _phonePictureBM.height)/2);
        _phonePictureBM.alpha = 0;
        _phonePictureBM.visible = false;
        addChild(_phonePictureBM);


        questionBM = new Bitmap(new QuestionBD());
        questionBM.x = Math.floor((_bcgBM.width - questionBM.width)/2);
        questionBM.y = Math.floor((_bcgBM.height - questionBM.height)/2);
        addChild(questionBM)


        /*var tf:TextField = new TextField();
        tf.text = String(cardType);
        addChild(tf);*/
    }



    private static function getCardBitmapByType(cardType:int):BitmapData {

        switch (cardType) {
            case TYPE_PHONE_1:
                return new PhonePic_1();

            case TYPE_PHONE_2 :
                return new PhonePic_2();

            case TYPE_PHONE_3 :
                return new PhonePic_3();

            case TYPE_PHONE_4 :
                return new PhonePic_4();

            case TYPE_PHONE_5:
                return new PhonePic_5();

            case TYPE_PHONE_6 :
                return new PhonePic_6();

            case TYPE_PHONE_7 :
                return new PhonePic_7();

            case TYPE_PHONE_8:
                return new PhonePic_8();

            case TYPE_PHONE_9:
                return new PhonePic_9();

            default: return new PhonePic_1();
        }

    }


/*
    public function setPicture(value:BitmapData):void {
        _phonePictureBM.bitmapData = value;

    }
*/


    public function open():void {
//        questionBM.visible = false;
        _phonePictureBM.visible = true;

        TweenLite.to(questionBM, 0.3, {alpha: 0,visible:false});
        TweenLite.to(_phonePictureBM, 0.3, {alpha: 1});
    }


    public function close():void {
        questionBM.visible = true;
//        _phonePictureBM.visible = false;

        TweenLite.to(questionBM, 0.3, {alpha: 1});
        TweenLite.to(_phonePictureBM, 0.3, {alpha: 0,visible:false});
    }


    public function get type():uint {
        return _type;
    }

    public function set type(value:uint):void {
        _type = value;
    }





}
}
