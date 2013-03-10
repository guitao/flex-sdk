////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2009 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package mx.accessibility
{

import flash.accessibility.Accessibility;
import flash.events.Event;
import mx.accessibility.AccImpl;
import mx.accessibility.AccConst;
import mx.core.UIComponent;
import mx.core.mx_internal;

import mx.controls.Label;

use namespace mx_internal;


/**
 *  LabelAccImpl is a subclass of AccessibilityImplementation
 *  which implements accessibility for the Label class.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class LabelAccImpl extends AccImpl
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Enables accessibility in the Label class.
     *
     *  <p>This method is called by application startup code
     *  that is autogenerated by the MXML compiler.
     *  Afterwards, when instances of Labels are initialized,
     *  their <code>accessibilityImplementation</code> property
     *  will be set to an instance of this class.</p>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static function enableAccessibility():void
    {
        Label.createAccessibilityImplementation =
            createAccessibilityImplementation;
    }

    /**
     *  @private
     *  Creates a Label's AccessibilityImplementation object.
     *  This method is called from UIComponent's
     *  initializeAccessibility() method.
     */
    mx_internal static function createAccessibilityImplementation(
                                component:UIComponent):void
    {
        component.accessibilityImplementation =
            new LabelAccImpl(component);
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param master The UIComponent instance that this AccImpl instance
     *  is making accessible.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function LabelAccImpl(master:UIComponent)
    {
        super(master);

        role = AccConst.ROLE_SYSTEM_STATICTEXT;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties: AccImpl
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  eventsToHandle
    //----------------------------------

    /**
     *  @private
     *    Array of events that we should listen for from the master component.
     */
    override protected function get eventsToHandle():Array
    {
        return super.eventsToHandle.concat(["updateComplete"]);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: AccessibilityImplementation
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  IAccessible method for returning the state of the Label.
     *  States are predefined for all the components in MSAA.
     *  Values are assigned to each state.
     *  Depending upon the Label being enabled,
     *  a state is returned.
     *
     *  @param childID uint
     *
     *  @return State uint
     */
    override public function get_accState(childID:uint):uint
    {
        var accState:uint = getState(childID);

        accState &= ~AccConst.STATE_SYSTEM_FOCUSABLE;
        
        accState |= AccConst.STATE_SYSTEM_READONLY;
        
        return accState;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: AccImpl
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  method for returning the name of the Label
     *  which is spoken out by the screen reader
     *  The Label should return the label inside as the name of the Label.
     *  The name in AccessibilityProperties is combined with the name
     *  specified here.
     *
     *  @param childID uint
     *
     *  @return Name String
     */
    override protected function getName(childID:uint):String
    {
        var label:String = Label(master).text;

        return label != null && label != "" ? label : "";
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: AccImpl
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Override the generic event handler.
     *  All AccImpl must implement this
     *  to listen for events from its master component.
     */
    override protected function eventHandler(event:Event):void
    {
        // Let AccImpl class handle the events
        // that all accessible UIComponents understand.
        $eventHandler(event);

        switch (event.type)
        {
            case "updateComplete":
            {
                Accessibility.sendEvent(master, 0, AccConst.EVENT_OBJECT_NAMECHANGE);
                Accessibility.updateProperties();
                break;
            }
        }
    }
}

}