import 'package:flutter/material.dart';

class ButtonAnimation extends StatefulWidget {
  final Color primaryColor;
  final Color darkPrimaryColor;

  ButtonAnimation(this.primaryColor, this.darkPrimaryColor);

  @override
  _ButtonAnimationState createState() => _ButtonAnimationState();
}

class _ButtonAnimationState extends State<ButtonAnimation> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _scaleAnimationController;
  AnimationController _fadeAnimationController;

  Animation<double> _animation;
  Animation<double> _scaleAnimation;
  Animation<double> _fadeAnimation;

  double buttonWidth = 200.0;
  double scale = 1.0;
  bool animationComplete = false;
  double barColorOpacity = .6;
  bool animationStart = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3)
    );

    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );

    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400)
    );

    _fadeAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(_fadeAnimationController);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(_scaleAnimationController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scaleAnimationController.reverse();
        _fadeAnimationController.forward();
        _animationController.forward();
      }
    });

    _animation = Tween<double>(
      begin: 0.0,
      end: buttonWidth
    ).animate(_animationController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          animationComplete = true;
          barColorOpacity = .0;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _animationController.dispose();
    _fadeAnimationController.dispose();
    _scaleAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          animation: _scaleAnimationController,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: InkWell(
              onTap: () {
                _scaleAnimationController.forward();
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: widget.primaryColor,
                  borderRadius: BorderRadius.circular(3)
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        child: 
                        animationComplete == false ?
                        Text("Download", style: TextStyle(color: Colors.white, fontSize: 16),)
                        :
                        Icon(Icons.check, color: Colors.white,)
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _fadeAnimationController,
                      builder: (context, child) => Container(
                        width: _fadeAnimation.value,
                        height: 50,
                        decoration: BoxDecoration(
                          color: widget.darkPrimaryColor,
                          borderRadius: BorderRadius.circular(3)
                        ),
                        child: Icon(Icons.arrow_downward, color: Colors.white,),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => Positioned(
            left: 0,
            top: 0,
            width: _animation.value,
            height: 50,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: barColorOpacity,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}