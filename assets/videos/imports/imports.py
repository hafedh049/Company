from manim import *


class Imports(Scene):
    def construct(self) -> None:
        t1: Text = Text("import", color=YELLOW)
        t2: Text = Text(
            "It is a reserved keyword that tells python\nto import such items",
            font_size=36,
        )
        vg: VGroup = VGroup()
        t3: Text = Text(
            "from module import item1, ...",
            t2c={
                "from": PURPLE,
                "module": YELLOW,
                "import": PURPLE,
                "item1": RED,
                "...": RED,
            },
        )
        t33: Text = Text("OR", color=BLUE).next_to(t3, direction=DOWN)
        t333: Text = Text(
            "from module import (item1, ...)",
            t2c={
                "from": PURPLE,
                "module": YELLOW,
                "import": PURPLE,
                "item1": RED,
                "...": RED,
            },
        ).next_to(t33, direction=DOWN)
        vg.add(t3, t33, t333).move_to(ORIGIN)
        vgrp: VGroup = VGroup()
        t4: Text = Text("item can be a ", t2c={"item": YELLOW})
        t5: List[Text] = [
            Text("class, ", t2c={"class": GREEN}),
            Text("variable, ", t2c={"variable": GREEN}),
            Text("function, ", t2c={"function": GREEN}),
            Text("module", t2c={"module": GREEN}),
        ]
        [t5[i].next_to(t5[i - 1], direction=RIGHT) for i in range(1, len(t5))]
        hvg: VGroup = VGroup(*t5).next_to(t4, direction=DOWN)
        vgrp.add(t4, hvg).move_to(ORIGIN)

        t6: Text = Text(
            "from module import *",
            t2c={
                "from": PURPLE,
                "module": YELLOW,
                "import": PURPLE,
                "*": YELLOW,
            },
        )

        t7: Text = Text(
            "from module import x as y",
            t2c={
                "from": PURPLE,
                "module": YELLOW,
                "import": PURPLE,
                "x": YELLOW,
                "as": PURPLE,
                "y": BLUE,
            },
        )

        t8: Text = Text(
            "import module",
            t2c={
                "module": YELLOW,
                "import": PURPLE,
            },
        )

        t9: Text = Text(
            "import module as alia",
            t2c={
                "module": YELLOW,
                "import": PURPLE,
                "as": PURPLE,
                "alia": BLUE,
            },
        )

        code1: Code = Code(
            code="from math import pi, cos, sin",
            font_size=22,
            insert_line_no=False,
            language="python",
        )

        code2: Code = Code(
            code="import cmath as complex_math",
            font_size=22,
            insert_line_no=False,
            language="python",
        )

        code3: Code = Code(
            code="from math import sin as si",
            font_size=22,
            insert_line_no=False,
            language="python",
        )

        code4: Code = Code(
            code="from math import *",
            font_size=22,
            insert_line_no=False,
            language="python",
        )

        self.play(Write(t1))
        self.wait(2)
        self.play(ReplacementTransform(t1, t2))
        self.wait(2)
        self.play(ReplacementTransform(t2, vg))
        self.wait(2)
        self.play(ReplacementTransform(vg, vgrp))
        self.wait(2)
        self.play(ReplacementTransform(vgrp, t6))
        self.wait(2)
        self.play(ReplacementTransform(t6, t7))
        self.wait(2)
        self.play(ReplacementTransform(t7, t8))
        self.wait(2)
        self.play(ReplacementTransform(t8, t9))
        self.wait(2)
        self.play(ReplacementTransform(t9, code1))
        self.wait(2)
        self.play(ReplacementTransform(code1, code2))
        self.wait(2)
        self.play(ReplacementTransform(code2, code3))
        self.wait(2)
        self.play(ReplacementTransform(code3, code4))
        self.wait(3)
