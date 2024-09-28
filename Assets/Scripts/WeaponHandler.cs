using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class WeaponHandler : MonoBehaviour
{

    [SerializeField] private Camera cam;
    [SerializeField] SpriteRenderer crosshair;
    bool crosshairShown;
    [SerializeField] Transform crosshairPosition;

    public void updateWeaponRotation(Vector2 position){
        //Vector2 mousePosition = cam.ScreenToWorldPoint(Input.mousePosition);
        //position = new Vector2(transform.position.x, transform.position.y);

        if(Mathf.Abs(Input.GetAxis("MoveWeaponHorizontal")) > 0.1f || Mathf.Abs(Input.GetAxis("MoveWeaponVertical")) > 0.1f){
            Vector2 joystickPosition = new Vector2(Input.GetAxis("MoveWeaponHorizontal"), Input.GetAxis("MoveWeaponVertical"));
            
            float angle = Vector2.Angle(joystickPosition, new Vector2(1f, 0f));

            //Debug.Log(angle);

            transform.rotation = Quaternion.Euler(0f, 0f, angle);

            if(Input.GetAxis("MoveWeaponVertical") > 0f){
                transform.rotation = Quaternion.Euler(0f, 0f, angle);
            }else{
                transform.rotation = Quaternion.Euler(0f, 0f, 360f - angle);
            }

            if(!crosshairShown){
                crosshairShown = true;
                Color tmp = crosshair.color;
                tmp.a = 1f;
                crosshair.color = tmp;
            }

            crosshairPosition.position = position + joystickPosition*2.5f;

        }else if(crosshairShown){
            Color tmp = crosshair.color;
            tmp.a = 0f;
            crosshair.color = tmp;
            crosshairShown = false;
        }
        /*
        if (transform.position.y <= mousePosition.y){
            transform.rotation = Quaternion.Euler(0f, 0f, angle);
        }else{
            transform.rotation = Quaternion.Euler(0f, 0f, 360f - angle);
        }
        */
        //Debug.Log(Input.GetAxis("MoveWeaponHorizontal"));
        //Debug.Log(Input.GetAxis("MoveWeaponVertical"));
    }
}
