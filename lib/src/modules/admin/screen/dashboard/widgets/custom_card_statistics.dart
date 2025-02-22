import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

class CustomCardStatistics extends StatelessWidget {
  const CustomCardStatistics({
    super.key,
    required this.context,
    this.cardColor,
    this.cardColorInner,
    this.l,
    this.r1,
    this.r2,
    this.r3,
    this.r1base,
    this.r2base,
    this.r3base,
    this.lbase,
  });

  final Color? cardColor;
  final Color? cardColorInner;
  final BuildContext context;
  final String? l;
  final String? r1;
  final String? r2;
  final String? r3;
  final String? r1base;
  final String? r2base;
  final String? r3base;
  final String? lbase;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor ?? const Color(0xFF1B213D),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      width: MediaQuery.of(context).size.width,
      height: 140,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cardColorInner ?? const Color(0xff2A2B4A),
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  (l ?? '2000').text.medium.size(24).color(Colors.orange),
                  const SizedBox(
                    height: 12.0,
                  ),
                  (lbase ?? 'Total').text.medium.size(16).color(Colors.white70),
                  const SizedBox(
                    height: 2.0,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: cardColorInner ?? const Color(0xff2A2B4A), width: 0.0),
                      color: cardColorInner ?? const Color(0xff2A2B4A),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 0.0,
                        ),
                        (r1 ?? '0').text.medium.color(Colors.green),
                        const SizedBox(
                          height: 2.0,
                        ),
                        (r1base ?? 'title').text.medium.color(Colors.white70),
                        const SizedBox(
                          height: 2.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: cardColorInner ?? const Color(0xff2A2B4A), width: 0.0),
                      color: cardColorInner ?? const Color(0xff2A2B4A),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    margin: const EdgeInsets.only(top: 6),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 0.0,
                        ),
                        (r2 ?? '0').text.medium.color(Colors.red),
                        const SizedBox(
                          height: 2.0,
                        ),
                        (r2base ?? 'Title').text.medium.color(Colors.white70),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
