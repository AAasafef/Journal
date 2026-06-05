import 'package:flutter/material.dart';

class DocumentImportSourceCard
    extends StatelessWidget {
  final IconData icon;

  final String title;

  final String subtitle;

  final VoidCallback onTap;

  const DocumentImportSourceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(
          18,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(
            24,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(
                .04,
              ),
              blurRadius: 18,
              offset: const Offset(
                0,
                10,
              ),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: const Color(
                  0xFFF4EFE8,
                ),
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
              child: Icon(
                icon,
                color: const Color(
                  0xFF6E5846,
                ),
              ),
            ),

            const SizedBox(
              width: 16,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight
                              .w400,
                      color: Color(
                        0xFF2D241D,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    subtitle,
                    style:
                        TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.black
                          .withOpacity(
                        .55,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 34,
              width: 34,
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFF4EFE8,
                ),
                borderRadius:
                    BorderRadius.circular(
                  999,
                ),
              ),
              child: const Icon(
                Icons
                    .arrow_forward_ios_rounded,
                size: 14,
                color: Color(
                  0xFFB08D6D,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
