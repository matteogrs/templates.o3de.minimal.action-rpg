# Contributing Guidelines

Thank you for your interest in contributing to **Minimal Action RPG Template for O3DE**. There are several ways in which you can support and help this project.

## Report issues

Please [open an issue](https://github.com/matteogrs/templates.o3de.minimal.action-rpg/issues) in our tracker if you have encountered any error. Provide a list of the steps that are required to reproduce the bug, and the error message that you have received (if any). You can also add any other detail about your current configuration (e.g. operating system, engine version) that might be relevant to narrow down the error.

Bear in mind that the project implementation may intentionally include flaws in terms of quality and optimization. Indeed, this project aims to be a quick and simple tool to start learning the fundamentals of game development without any prior experience. Thus, all features are implemented preferring simplicity and readibility over efficiency. This can result in missing sanity checks, inefficient data structures and algorithms, etc. in order to make the code more understandable for beginners, but at the same time easily upgradable for experts.

## Suggest new features

If you feel that something is missing, you can [add a feature request](https://github.com/matteogrs/templates.o3de.minimal.action-rpg/issues) to our tracker. Provide a brief introduction of your idea, pointing out which use-cases / scenarios could address and what benefits users can obtain. You can also add any technical detail that you think might be useful to help maintainers and other contributors evaluating your suggestion.

We try to keep this project as small as possible, so that it takes only few minutes to jump in and get comfortable with the entire codebase. Thus, new features have to be strictly related to the core mechanics of this game genre. It should also be self-explanatory, usable without any visual/audio effect, and not relying upon any external dependency.

In general, games tend to mix features from different genres in order to be more innovative and fun. It is not easy to draw a clear line between them, in order to define how much a feature is distinctive of a specific genre. In case you are unsure, try to submit your suggestion anyway. If the feature is not eligible for the main project, it can still be evaluated for the [Next Steps](https://github.com/matteogrs/templates.o3de.minimal.action-rpg/#next-steps) section.

## Submit changes

If you want to apply changes to the code, you can [open a change proposal](https://github.com/matteogrs/templates.o3de.minimal.action-rpg/issues) in our tracker to introduce the need that you are facing, and describe what you are going to implement. A maintainer can give you an initial opinion, so that you can focus on the parts that are more helpful for this project.

Note that this process does not constitute a contract, and there are no obligations between parties to complete / accept the proposed changes. It just makes maintainers and other contributors aware of which improvements might be available in the future. And, it helps you saving time since you can start designing your changes in a way that are already useful for the project, even before implementing them.

When your change is completed, you can submit the code to this repository by [creating a new pull request (PR)](https://github.com/matteogrs/templates.o3de.minimal.action-rpg/pulls). But, before doing that, please take care to examine the next section.

### Sign-off

Contributors are required to agree to the following Developer Certificate of Origin (DCO), that is taken from [https://developercertificate.org](https://developercertificate.org):

```
Developer Certificate of Origin
Version 1.1

Copyright (C) 2004, 2006 The Linux Foundation and its contributors.

Everyone is permitted to copy and distribute verbatim copies of this
license document, but changing it is not allowed.


Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
```

To certify these requirements, append the following line (*sign-off*) to every commit message, filling it with your real name (no pseudonyms):

```
[...]

Signed-off-by: Name Surname <name.surname@domain.ext>
```

NOTE: Use `-s` option in the Git command line to add the sign-off automatically.
